import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:auth/auth.dart';

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
  StreamSubscription<CallNotificationActionEvent>?
      _notificationActionSubscription;
  final CallKitEventHandler _callKitHandler = CallKitEventHandler();

  IncomingCallHandler(this._ref, {required this.navigatorKey});

  /// Initialize handlers
  void initialize() {
    // Initialize CallKit event handler
    _callKitHandler.initialize();

    // Listen for CallKit actions (accept/decline from notification)
    _callKitSubscription = _callKitHandler.actions.listen(_handleCallKitAction);

    // Listen for foreground messages
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for accept/decline/open actions from fallback call notifications
    _notificationActionSubscription =
        CallNotificationService.onCallAction.listen(_handleNotificationAction);
    developer.log(
      '[CALL_ACTION] IncomingCallHandler notification action listener attached',
      name: 'Calls',
    );
    print(
      '[CALL_ACTION] IncomingCallHandler notification action listener attached',
    );

    // Ensure local notification action callbacks are initialized on app start.
    // This allows action taps (Accept/Decline) to be recovered when app is
    // resumed/launched from a notification interaction.
    unawaited(CallNotificationService.initializeActionHandling());

    developer.log('IncomingCallHandler initialized', name: 'Calls');
  }

  /// Handle foreground push messages
  void _handleForegroundMessage(RemoteMessage message) {
    final type = (message.data['type'] ?? '').toString().toLowerCase();

    if (type == 'incoming_call' || type == 'call_invite') {
      _handleIncomingCall(message.data);
    } else if (type == 'call_status' || type == 'call_event') {
      _handleCallStatusUpdate(message.data);
    }
  }

  /// Handle incoming call notification
  void _handleIncomingCall(Map<String, dynamic> data) {
    final callId = (data['callId'] ?? data['call_id'])?.toString();
    final callType = (data['callType'] ?? data['call_type'])?.toString();
    final callerName =
        (data['callerName'] ?? data['caller_name'] ?? data['senderName'])
            ?.toString();
    var callerUserId =
        (data['callerUserId'] ?? data['caller_user_id'] ?? data['senderUserId'])
            ?.toString();
    final callerAvatar =
        (data['callerAvatar'] ?? data['caller_avatar'])?.toString();

    if ((callerUserId == null || callerUserId.isEmpty) &&
        callId != null &&
        callId.isNotEmpty) {
      callerUserId = '_unknown_$callId';
    }

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
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
          isVideo: callType == 'video',
        );
      }
    }
  }

  Future<void> _handleNotificationAction(
      CallNotificationActionEvent event) async {
    try {
      await _handleNotificationActionInner(event);
    } catch (e, st) {
      developer.log(
        '[CALL_ACTION] UNHANDLED ERROR in notification action handler: $e',
        name: 'Calls',
        stackTrace: st,
      );
      print('[CALL_ACTION] UNHANDLED ERROR in notification action handler: $e');
    }
  }

  Future<void> _handleNotificationActionInner(
      CallNotificationActionEvent event) async {
    final controller = _ref.read(callControllerProvider.notifier);
    final guard = _ref.read(callNavigationGuardProvider(navigatorKey));
    developer.log(
      '[CALL_ACTION] received action=${event.type.name} callId=${event.callId}',
      name: 'Calls',
    );
    print(
      '[CALL_ACTION] received action=${event.type.name} callId=${event.callId}',
    );

    var hydrated = await _ensureIncomingStateForAction(event, controller);
    if (!hydrated && _ref.read(authNotifierProvider).valueOrNull == null) {
      developer.log(
        '[CALL_ACTION] auth not ready; retrying hydration for callId=${event.callId}',
        name: 'Calls',
      );
      print(
        '[CALL_ACTION] auth not ready; retrying hydration for callId=${event.callId}',
      );

      for (var attempt = 1; attempt <= 10 && !hydrated; attempt++) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (_ref.read(authNotifierProvider).valueOrNull == null) {
          continue;
        }
        hydrated = await _ensureIncomingStateForAction(event, controller);
        developer.log(
          '[CALL_ACTION] hydration retry attempt=$attempt success=$hydrated',
          name: 'Calls',
        );
        print(
          '[CALL_ACTION] hydration retry attempt=$attempt success=$hydrated',
        );
      }
    }

    switch (event.type) {
      case CallNotificationActionType.open:
        if (!hydrated) {
          developer.log(
            'Ignoring open action for call ${event.callId}: unable to hydrate state',
            name: 'Calls',
          );
          return;
        }
        guard.showIncomingCallScreen(
          callId: event.callId,
          callType: event.isVideo ? CallType.video : CallType.audio,
          callerName: event.callerName,
          callerUserId: event.callerUserId,
        );
        break;
      case CallNotificationActionType.accept:
        if (!hydrated) {
          developer.log(
            'Ignoring accept action for call ${event.callId}: unable to hydrate state',
            name: 'Calls',
          );
          return;
        }
        try {
          final preAcceptState = _ref.read(callControllerProvider);
          developer.log(
            '[CALL_ACTION] about to call acceptCall() state=${preAcceptState.runtimeType} callId=${event.callId}',
            name: 'Calls',
          );
          print(
            '[CALL_ACTION] about to call acceptCall() state=${preAcceptState.runtimeType} callId=${event.callId}',
          );
          await controller.acceptCall();
          final postAcceptState = _ref.read(callControllerProvider);
          developer.log(
            '[CALL_ACTION] acceptCall() completed state=${postAcceptState.runtimeType} callId=${event.callId}',
            name: 'Calls',
          );
          print(
            '[CALL_ACTION] acceptCall() completed state=${postAcceptState.runtimeType} callId=${event.callId}',
          );

          // Only navigate to InCallScreen if accept was successful (state is InCall or Connecting)
          // If state is CallError or Idle, the call failed - don't show black screen
          if (postAcceptState is CallError || postAcceptState is CallIdle) {
            developer.log(
              '[CALL_ACTION] accept failed, state=$postAcceptState - not navigating to InCallScreen',
              name: 'Calls',
            );
            print(
              '[CALL_ACTION] accept failed, state=${postAcceptState.runtimeType} - not navigating to InCallScreen',
            );
            guard.popToRootAndClear();
          } else {
            guard.showInCallScreen();
            developer.log(
              '[CALL_ACTION] showInCallScreen() called for callId=${event.callId}',
              name: 'Calls',
            );
            print(
              '[CALL_ACTION] showInCallScreen() called for callId=${event.callId}',
            );
          }
        } catch (e, st) {
          developer.log(
            '[CALL_ACTION] accept flow FAILED for callId=${event.callId}: $e',
            name: 'Calls',
            stackTrace: st,
          );
          print(
            '[CALL_ACTION] accept flow FAILED for callId=${event.callId}: $e',
          );
          // On error, ensure we don't leave user on black screen
          guard.popToRootAndClear();
        }
        break;
      case CallNotificationActionType.decline:
        if (!hydrated) {
          developer.log(
            'Ignoring decline action for call ${event.callId}: unable to hydrate state',
            name: 'Calls',
          );
          return;
        }
        await controller.declineCall(reason: 'declined_from_notification');
        guard.popToRootAndClear();
        break;
    }
  }

  Future<bool> _ensureIncomingStateForAction(
    CallNotificationActionEvent event,
    CallController controller,
  ) async {
    final state = _ref.read(callControllerProvider);
    if (state is IncomingRinging && state.callId == event.callId) {
      developer.log(
        '[CALL_ACTION] already in IncomingRinging for callId=${event.callId}',
        name: 'Calls',
      );
      return true;
    }

    var callType = event.isVideo ? CallType.video : CallType.audio;
    var callerName = event.callerName;
    var callerUserId = event.callerUserId;
    String? callerAvatar;

    if (callerUserId.isEmpty) {
      try {
        final session = await _ref
            .read(callsRepositoryProvider)
            .getCallDetails(event.callId);
        callType = session.callType;
        final currentUserId =
            _ref.read(authNotifierProvider).valueOrNull?.user.id;
        final remote = currentUserId == null
            ? (session.initiator ?? session.recipient)
            : session.getRemoteParticipant(currentUserId);
        if (remote != null) {
          callerUserId = remote.userId;
          callerName = remote.name;
          callerAvatar = remote.avatar;
        }
        developer.log(
          '[CALL_ACTION] getCallDetails resolved callerUserId=$callerUserId callType=${callType.name}',
          name: 'Calls',
        );
        print(
          '[CALL_ACTION] getCallDetails resolved callerUserId=$callerUserId callType=${callType.name}',
        );
      } catch (e) {
        developer.log(
          'Failed to resolve caller details for notification action: $e',
          name: 'Calls',
        );
        print(
          '[CALL_ACTION] getCallDetails failed callId=${event.callId} error=$e',
        );
      }
    }

    if (callerUserId.isEmpty) {
      callerUserId = '_unknown_${event.callId}';
      developer.log(
        '[CALL_ACTION] callerUserId missing, using fallback=$callerUserId',
        name: 'Calls',
      );
      print(
        '[CALL_ACTION] callerUserId missing, using fallback=$callerUserId',
      );
    }

    await controller.handleIncomingCall(
      callId: event.callId,
      callType: callType,
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
    );

    final hydratedState = _ref.read(callControllerProvider);
    final success = hydratedState is IncomingRinging &&
        hydratedState.callId == event.callId;
    developer.log(
      '[CALL_ACTION] hydration result success=$success callId=${event.callId}',
      name: 'Calls',
    );
    print(
      '[CALL_ACTION] hydration result success=$success callId=${event.callId}',
    );
    return success;
  }

  /// Handle call status update from push
  void _handleCallStatusUpdate(Map<String, dynamic> data) {
    final callId = (data['callId'] ?? data['call_id'])?.toString();
    final status = (data['status'] ?? data['event'])?.toString().toLowerCase();

    if (callId == null || status == null) return;

    developer.log('Call status update: $callId -> $status', name: 'Calls');

    if (status == 'accepted' || status == 'ended' || status == 'declined') {
      // Cleanup CallKit UI
      CallNotificationService.endCall(callId);
    }
  }

  /// Handle CallKit action (user tapped accept/decline on notification)
  void _handleCallKitAction(CallKitAction action) {
    final callId = action.callId;
    final guard = _ref.read(callNavigationGuardProvider(navigatorKey));

    switch (action) {
      case CallKitAccepted():
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
        _ref
            .read(callControllerProvider.notifier)
            .declineCall(reason: 'No answer');
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
    _notificationActionSubscription?.cancel();
    _callKitHandler.dispose();
  }
}

// Provider for IncomingCallHandler
final incomingCallHandlerProvider =
    Provider.family<IncomingCallHandler, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final handler = IncomingCallHandler(ref, navigatorKey: navigatorKey);
  ref.onDispose(() => handler.dispose());
  return handler;
});
