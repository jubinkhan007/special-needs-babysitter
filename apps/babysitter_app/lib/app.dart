import 'dart:async';
import 'dart:developer' as developer;

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
import 'src/features/calls/services/chat_call_invite_polling_handler.dart';
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
  ChatCallInvitePollingHandler? _chatCallInvitePollingHandler;
  bool _isForeground = true;
  bool _notificationsInitialized = false;
  bool _isRegisteringFcmToken = false;
  bool _bootstrappedAuthCheck = false;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<String?>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionTrackingControllerProvider.notifier).restoreSession();
      _initializeIncomingCallHandler();
      _maybeStartIncomingCallPolling();
      _maybeStartChatInvitePolling();
      _initializeNotifications();
    });
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _notificationTapSubscription?.cancel();
    _incomingCallHandler?.dispose();
    _incomingCallPollingHandler?.dispose();
    _chatCallInvitePollingHandler?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (!_isForeground) {
      _incomingCallPollingHandler?.stop();
      _chatCallInvitePollingHandler?.stop();
    } else {
      _maybeStartIncomingCallPolling();
      _maybeStartChatInvitePolling();
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
      _maybeStartChatInvitePolling();

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
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
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

  void _maybeStartChatInvitePolling() {
    if (!_isForeground) {
      _chatCallInvitePollingHandler?.stop();
      return;
    }

    final user = ref.read(authNotifierProvider).valueOrNull?.user;
    if (user == null || !user.isSitter) {
      _chatCallInvitePollingHandler?.stop();
      return;
    }

    _chatCallInvitePollingHandler ??=
        ref.read(chatCallInvitePollingHandlerProvider(rootNavigatorKey));
    _chatCallInvitePollingHandler?.start();
  }

  Future<void> _initializeNotifications() async {
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

      // Run diagnostics to help debug notification issues
      await notificationsService.runDiagnostics();
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
        await notificationsService.runDiagnostics();
      }
    } catch (e, st) {
      developer.log('Failed to register FCM token with backend: $e',
          name: 'Notifications', stackTrace: st);
      _logFcmFlow('_registerFcmToken failed with error=$e');
    } finally {
      _isRegisteringFcmToken = false;
    }
  }

  String _maskToken(String token) {
    if (token.length <= 12) {
      return token;
    }
    return '${token.substring(0, 8)}...${token.substring(token.length - 4)}';
  }

  void _logFcmFlow(String message) {
    developer.log(message, name: 'FCM_FLOW');
    print('[FCM_FLOW] $message');
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

    _logFcmFlow('notification tap ignored: unsupported payload=$cleaned');
  }
}
