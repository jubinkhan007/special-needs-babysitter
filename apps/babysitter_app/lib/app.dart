import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:auth/auth.dart';
import 'package:notifications/notifications.dart';

import 'src/routing/app_router.dart';
import 'src/features/sitter/bookings/presentation/providers/session_tracking_providers.dart';
import 'src/features/calls/services/incoming_call_handler.dart';
import 'src/features/calls/services/incoming_call_polling_handler.dart';
import 'src/features/calls/services/call_notification_service.dart';
import 'src/features/calls/services/call_navigation_guard.dart';
import 'src/features/calls/domain/entities/call_enums.dart';
import 'src/features/calls/presentation/providers/calls_providers.dart';

/// Main application widget
class BabysitterApp extends ConsumerStatefulWidget {
  const BabysitterApp({super.key});

  @override
  ConsumerState<BabysitterApp> createState() => _BabysitterAppState();
}

class _BabysitterAppState extends ConsumerState<BabysitterApp>
    with WidgetsBindingObserver {
  IncomingCallHandler? _incomingCallHandler;
  bool _incomingCallHandlerInitialized = false;
  IncomingCallPollingHandler? _incomingCallPollingHandler;
  bool _isForeground = true;
  bool _notificationsInitialized = false;
  bool _isRegisteringFcmToken = false;
  Timer? _fcmTokenRetryTimer;
  int _fcmTokenRetryAttempts = 0;
  static const int _maxFcmTokenRetryAttempts = 5;
  bool _hasRunFcmDiagnostics = false;
  bool _bootstrappedAuthCheck = false;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<String?>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize notification/call action handling as early as possible to
    // avoid showing home briefly before incoming-call UI on cold starts.
    Future.microtask(_initializeNotificationsAndCallHandler);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionTrackingControllerProvider.notifier).restoreSession();
      _maybeStartIncomingCallPolling();
    });
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _notificationTapSubscription?.cancel();
    _fcmTokenRetryTimer?.cancel();
    _incomingCallHandler?.dispose();
    _incomingCallPollingHandler?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (!_isForeground) {
      _incomingCallPollingHandler?.stop();
    } else {
      _maybeStartIncomingCallPolling();
    }
    Future.microtask(() {
      ref
          .read(sessionTrackingControllerProvider.notifier)
          .handleAppLifecycle(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      final userId = next.valueOrNull?.user.id;
      if (userId != null && userId.isNotEmpty) {
        ref.read(callControllerProvider.notifier).setCurrentUserId(userId);
      }
      _maybeStartIncomingCallPolling();

      // Register FCM token when user becomes authenticated
      final wasAuthenticated = previous?.valueOrNull != null;
      final isAuthenticated = next.valueOrNull != null;
      _logFcmFlow(
        'authListener fired wasAuthenticated=$wasAuthenticated isAuthenticated=$isAuthenticated',
      );
      if (!wasAuthenticated && isAuthenticated) {
        _logFcmFlow('authListener -> triggering _registerFcmToken');
        _registerFcmToken();
      }
    });

    if (!_bootstrappedAuthCheck) {
      _bootstrappedAuthCheck = true;
      final currentSession = ref.read(authNotifierProvider).valueOrNull;
      _logFcmFlow(
        'build bootstrap auth check sessionPresent=${currentSession != null}',
      );
      if (currentSession != null) {
        _logFcmFlow('build bootstrap -> triggering _registerFcmToken');
        _registerFcmToken();
      }
    }

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: Constants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          routerConfig: router,
        );
      },
    );
  }

  void _initializeIncomingCallHandler() {
    if (_incomingCallHandlerInitialized) return;
    final firebaseReady = ref.read(firebaseReadyProvider);
    if (!firebaseReady) return;

    _incomingCallHandler =
        ref.read(incomingCallHandlerProvider(rootNavigatorKey));
    _incomingCallHandler?.initialize();
    _incomingCallHandlerInitialized = true;
  }

  void _maybeStartIncomingCallPolling() {
    final firebaseReady = ref.read(firebaseReadyProvider);
    if (firebaseReady || !_isForeground) {
      _incomingCallPollingHandler?.stop();
      return;
    }

    final user = ref.read(authNotifierProvider).valueOrNull?.user;
    if (user == null || !user.isSitter) {
      _incomingCallPollingHandler?.stop();
      return;
    }

    _incomingCallPollingHandler ??=
        ref.read(incomingCallPollingHandlerProvider(rootNavigatorKey));
    _incomingCallPollingHandler?.start();
  }


  Future<void> _initializeNotificationsAndCallHandler() async {
    if (_notificationsInitialized) return;
    final firebaseReady = ref.read(firebaseReadyProvider);
    if (!firebaseReady) {
      _logFcmFlow('_initializeNotifications skipped: firebaseReady=false');
      return;
    }

    _notificationsInitialized = true;
    _logFcmFlow('_initializeNotifications starting');

    try {
      final notificationsService = ref.read(notificationsServiceProvider);
      await notificationsService.initialize();

      // Set up fallback handler so CallNotificationService can forward
      // non-call notification taps to the main notification handler.
      CallNotificationService.fallbackNotificationTapHandler =
          _handleNotificationTap;

      // Initialize call notification handler AFTER main notification service.
      // This ensures CallNotificationService's callback is registered LAST
      // on the shared FlutterLocalNotificationsPlugin method channel,
      // so call action buttons (Accept/Decline) are properly handled.
      _initializeIncomingCallHandler();

      // Request push permission after call action handling is ready.
      // This avoids delaying incoming call UI when app is opened from lock-screen.
      await notificationsService.requestPermission();

      // Register token if user is already authenticated
      final session = ref.read(authNotifierProvider).valueOrNull;
      if (session != null) {
        _logFcmFlow(
          '_initializeNotifications found existing session userId=${session.user.id}',
        );
        _registerFcmToken();
      } else {
        _logFcmFlow(
          '_initializeNotifications found no session yet; waiting for auth listener',
        );
      }

      // Listen to token refreshes and re-register with backend
      _tokenRefreshSubscription =
          notificationsService.onTokenRefresh.listen((newToken) async {
        final currentSession = ref.read(authNotifierProvider).valueOrNull;
        if (currentSession != null && newToken.isNotEmpty) {
          try {
            final dataSource = ref.read(authRemoteDataSourceProvider);
            await dataSource.registerDeviceToken(newToken);
            developer.log('Re-registered refreshed FCM token',
                name: 'Notifications');
          } catch (e) {
            developer.log('Failed to re-register refreshed FCM token: $e',
                name: 'Notifications');
          }
        }
      });

      _notificationTapSubscription =
          notificationsService.onNotificationTap.listen((payload) {
        _handleNotificationTap(payload);
      });

      developer.log('Notifications initialized in app', name: 'Notifications');

      await _runFcmDiagnosticsOnce(
        notificationsService,
        reason: 'notifications_initialized',
      );
    } catch (e) {
      developer.log('Failed to initialize notifications: $e',
          name: 'Notifications');
    }
  }

  Future<void> _registerFcmToken() async {
    if (_isRegisteringFcmToken) {
      _logFcmFlow('_registerFcmToken skipped: already in progress');
      return;
    }

    _isRegisteringFcmToken = true;
    try {
      _logFcmFlow('_registerFcmToken started');
      final notificationsService = ref.read(notificationsServiceProvider);
      String? token = await notificationsService.getToken();
      _logFcmFlow(
        '_registerFcmToken getToken result: ${token == null || token.isEmpty ? "empty" : "len=${token.length}"}',
      );
      if (token == null || token.isEmpty) {
        developer.log(
          'FCM token missing on first attempt, trying forced refresh',
          name: 'Notifications',
        );
        token = await notificationsService.forceRefreshToken();
        _logFcmFlow(
          '_registerFcmToken forceRefreshToken result: ${token == null || token.isEmpty ? "empty" : "len=${token.length}"}',
        );
      }

      if (token != null && token.isNotEmpty) {
        _fcmTokenRetryTimer?.cancel();
        _fcmTokenRetryTimer = null;
        _fcmTokenRetryAttempts = 0;
        final dataSource = ref.read(authRemoteDataSourceProvider);
        _logFcmFlow('_registerFcmToken calling backend registerDeviceToken');
        await dataSource.registerDeviceToken(token);
        developer.log('FCM token registered with backend: ${_maskToken(token)}',
            name: 'Notifications');
        _logFcmFlow('_registerFcmToken backend registration success');
      } else {
        developer.log(
          'FCM token still unavailable after forced refresh; push cannot be received',
          name: 'Notifications',
        );
        _logFcmFlow(
          '_registerFcmToken aborted: token unavailable after forced refresh',
        );
        await _runFcmDiagnosticsOnce(
          notificationsService,
          reason: 'token_unavailable',
        );
        _scheduleFcmTokenRetry();
      }
    } catch (e, st) {
      developer.log('Failed to register FCM token with backend: $e',
          name: 'Notifications', stackTrace: st);
      _logFcmFlow('_registerFcmToken failed with error=$e');
      _scheduleFcmTokenRetry();
    } finally {
      _isRegisteringFcmToken = false;
    }
  }

  void _scheduleFcmTokenRetry() {
    if (_fcmTokenRetryAttempts >= _maxFcmTokenRetryAttempts) {
      _logFcmFlow(
        '_registerFcmToken retry limit reached; giving up for this session',
      );
      return;
    }
    if (_fcmTokenRetryTimer?.isActive == true) {
      return;
    }

    final attempt = _fcmTokenRetryAttempts + 1;
    final delay = Duration(seconds: 2 * attempt);
    _fcmTokenRetryAttempts = attempt;
    _logFcmFlow(
      '_registerFcmToken scheduling retry attempt=$attempt after ${delay.inSeconds}s',
    );

    _fcmTokenRetryTimer = Timer(delay, () {
      final session = ref.read(authNotifierProvider).valueOrNull;
      if (session == null) {
        _logFcmFlow('_registerFcmToken retry skipped: no authenticated session');
        return;
      }
      _registerFcmToken();
    });
  }

  Future<void> _runFcmDiagnosticsOnce(
    NotificationsService notificationsService, {
    required String reason,
  }) async {
    if (!kDebugMode) {
      return;
    }
    if (_hasRunFcmDiagnostics) {
      _logFcmFlow('runDiagnostics skipped: already executed once');
      return;
    }

    _hasRunFcmDiagnostics = true;
    _logFcmFlow('runDiagnostics executing reason=$reason');
    await notificationsService.runDiagnostics();
  }

  String _maskToken(String token) {
    if (token.length <= 12) {
      return token;
    }
    return '${token.substring(0, 8)}...${token.substring(token.length - 4)}';
  }

  void _logFcmFlow(String message) {
    developer.log(message, name: 'FCM_FLOW');
    debugPrint('[FCM_FLOW] $message');
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      _logFcmFlow('notification tap ignored: empty payload');
      return;
    }

    final cleaned = payload.trim();
    final user = ref.read(authNotifierProvider).valueOrNull?.user;
    final context = rootNavigatorKey.currentContext;

    if (context == null) {
      _logFcmFlow('notification tap ignored: navigator context unavailable');
      return;
    }

    if (cleaned.startsWith('/')) {
      _logFcmFlow('notification tap navigating to route=$cleaned');
      GoRouter.of(context).go(cleaned);
      return;
    }

    if (cleaned.startsWith('chat:')) {
      final otherUserId = cleaned.substring('chat:'.length).trim();
      if (otherUserId.isEmpty) {
        _logFcmFlow('notification tap ignored: missing chat user id');
        return;
      }

      final isSitter = user?.isSitter == true;
      final route = isSitter
          ? '/sitter/messages/chat/$otherUserId'
          : '/parent/messages/chat/$otherUserId';
      _logFcmFlow('notification tap opening chat route=$route');
      GoRouter.of(context).go(route);
      return;
    }

    if (_looksLikeCallPayload(cleaned)) {
      _logFcmFlow(
          'notification tap detected call payload, routing to call flow');
      unawaited(_handleCallPayloadTap(cleaned));
      return;
    }

    _logFcmFlow('notification tap ignored: unsupported payload=$cleaned');
  }

  bool _looksLikeCallPayload(String payload) {
    final trimmed = payload.trim();
    return trimmed.startsWith('{') && trimmed.contains('"callId"');
  }

  Future<void> _handleCallPayloadTap(String payload) async {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        _logFcmFlow('call payload ignored: invalid JSON structure');
        return;
      }

      final callId = decoded['callId']?.toString().trim() ?? '';
      if (callId.isEmpty) {
        _logFcmFlow('call payload ignored: missing callId');
        return;
      }

      var callerName = decoded['callerName']?.toString().trim();
      var callerUserId = decoded['callerUserId']?.toString().trim();
      final isVideo = decoded['isVideo'] == true ||
          decoded['callType']?.toString().toLowerCase() == 'video';
      final callType = isVideo ? CallType.video : CallType.audio;

      // Wait briefly for auth restore if app was cold-started from a notif tap.
      for (var attempt = 0; attempt < 10; attempt++) {
        if (ref.read(authNotifierProvider).valueOrNull != null) break;
        await Future<void>.delayed(const Duration(seconds: 1));
      }

      if (callerUserId == null || callerUserId.isEmpty) {
        try {
          final session =
              await ref.read(callsRepositoryProvider).getCallDetails(callId);
          final currentUserId =
              ref.read(authNotifierProvider).valueOrNull?.user.id;
          final remote = currentUserId == null
              ? (session.initiator ?? session.recipient)
              : session.getRemoteParticipant(currentUserId);
          if (remote != null) {
            callerUserId = remote.userId;
            callerName = remote.name;
          }
        } catch (e) {
          _logFcmFlow(
              'call payload getCallDetails failed callId=$callId error=$e');
        }
      }

      callerUserId = (callerUserId == null || callerUserId.isEmpty)
          ? '_unknown_$callId'
          : callerUserId;
      callerName =
          (callerName == null || callerName.isEmpty) ? 'Caller' : callerName;

      final controller = ref.read(callControllerProvider.notifier);
      await controller.handleIncomingCall(
        callId: callId,
        callType: callType,
        callerName: callerName,
        callerUserId: callerUserId,
      );
      await controller.acceptCall();

      ref
          .read(callNavigationGuardProvider(rootNavigatorKey))
          .showInCallScreen();
      _logFcmFlow('call payload handled: accepted callId=$callId');
    } catch (e) {
      _logFcmFlow('call payload handling failed: $e');
    }
  }
}
