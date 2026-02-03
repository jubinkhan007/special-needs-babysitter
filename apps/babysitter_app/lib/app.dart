import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionTrackingControllerProvider.notifier).restoreSession();
      _initializeIncomingCallHandler();
      _maybeStartIncomingCallPolling();
      _maybeStartChatInvitePolling();
    });
  }

  @override
  void dispose() {
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
    });

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
}
