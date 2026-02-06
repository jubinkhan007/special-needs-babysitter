import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../domain/entities/call_enums.dart';
import '../presentation/controllers/call_controller.dart';
import '../presentation/controllers/call_state.dart';
import '../presentation/providers/calls_providers.dart';
import 'call_navigation_guard.dart';
import 'call_notification_service.dart';
import 'callkit_event_handler.dart';

/// Handles incoming call notifications and CallKit events
///
/// This integrates push notifications with the CallController
class IncomingCallHandler {
  final Ref _ref;
  final GlobalKey<NavigatorState> navigatorKey;

  StreamSubscription? _foregroundSubscription;
  StreamSubscription? _callKitSubscription;
  final CallKitEventHandler _callKitHandler = CallKitEventHandler();

  IncomingCallHandler(this._ref, {required this.navigatorKey});

  /// Initialize handlers
  void initialize() {
    // Initialize CallKit event handler
    _callKitHandler.initialize();

    // Listen for CallKit actions (accept/decline from notification)
    _callKitSubscription = _callKitHandler.actions.listen(_handleCallKitAction);

    // Listen for foreground messages
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    developer.log('IncomingCallHandler initialized', name: 'Calls');
  }

  /// Handle foreground push messages
  void _handleForegroundMessage(RemoteMessage message) {
    final type = message.data['type'];

    if (type == 'incoming_call') {
      _handleIncomingCall(message.data);
    } else if (type == 'call_status') {
      _handleCallStatusUpdate(message.data);
    }
  }

  /// Handle incoming call notification
  void _handleIncomingCall(Map<String, dynamic> data) {
    final callId = data['callId'] as String?;
    final callType = data['callType'] as String?;
    final callerName = data['callerName'] as String?;
    final callerUserId = data['callerUserId'] as String?;
    final callerAvatar = data['callerAvatar'] as String?;

    if (callId == null || callerName == null || callerUserId == null) {
      developer.log('Invalid incoming call data', name: 'Calls');
      return;
    }

    // Update controller state (this handles busy detection)
    _ref.read(callControllerProvider.notifier).handleIncomingCall(
      callId: callId,
      callType: CallType.fromString(callType ?? 'audio'),
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
    );

    // Check if controller accepted the call (not busy)
    final state = _ref.read(callControllerProvider);
    if (state is IncomingRinging && state.callId == callId) {
      // Show in-app incoming call screen (guard prevents duplicates)
      final guard = _ref.read(callNavigationGuardProvider(navigatorKey));
      final shown = guard.showIncomingCallScreen(
        callId: callId,
        callType: CallType.fromString(callType ?? 'audio'),
        callerName: callerName,
        callerUserId: callerUserId,
        callerAvatar: callerAvatar,
      );

      // Also show CallKit UI for system integration (only if screen was shown)
      if (shown) {
        CallNotificationService.showIncomingCallUI(
          callId: callId,
          callerName: callerName,
          callerAvatar: callerAvatar,
          isVideo: callType == 'video',
        );
      }
    }
  }

  /// Handle call status update from push
  void _handleCallStatusUpdate(Map<String, dynamic> data) {
    final callId = data['callId'] as String?;
    final status = data['status'] as String?;

    if (callId == null || status == null) return;

    developer.log('Call status update: $callId -> $status', name: 'Calls');

    // The controller will handle status updates via polling
    // Push updates are supplementary for faster response
    final currentState = _ref.read(callControllerProvider);

    if (status == 'ended' || status == 'declined') {
      // Cleanup CallKit UI
      CallNotificationService.endCall(callId);
    }
  }

  /// Handle CallKit action (user tapped accept/decline on notification)
  void _handleCallKitAction(CallKitAction action) {
    final callId = action.callId;
    final guard = _ref.read(callNavigationGuardProvider(navigatorKey));

    switch (action) {
      case CallKitAccepted(:final isVideo):
        developer.log('CallKit: User accepted $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).acceptCall();
        guard.showInCallScreen();
        break;

      case CallKitDeclined():
        developer.log('CallKit: User declined $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).declineCall();
        guard.popToRootAndClear();
        break;

      case CallKitEnded():
        developer.log('CallKit: Call ended $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).endCall();
        guard.popToRootAndClear();
        break;

      case CallKitTimedOut():
        developer.log('CallKit: Call timed out $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).declineCall(reason: 'No answer');
        guard.popToRootAndClear();
        break;

      case CallKitMissed():
        developer.log('CallKit: Missed call $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).reset();
        guard.reset();
        break;
    }
  }

  /// Dispose resources
  void dispose() {
    _foregroundSubscription?.cancel();
    _callKitSubscription?.cancel();
    _callKitHandler.dispose();
  }
}

// Provider for IncomingCallHandler
final incomingCallHandlerProvider = Provider.family<IncomingCallHandler, GlobalKey<NavigatorState>>((ref, navigatorKey) {
  final handler = IncomingCallHandler(ref, navigatorKey: navigatorKey);
  ref.onDispose(() => handler.dispose());
  return handler;
});
