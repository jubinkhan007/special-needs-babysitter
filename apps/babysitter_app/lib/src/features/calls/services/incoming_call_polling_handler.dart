import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/call_enums.dart';
import '../presentation/controllers/call_state.dart';
import '../presentation/providers/calls_providers.dart';
import 'call_navigation_guard.dart';

/// Polls call history to detect incoming ringing calls when FCM is unavailable.
class IncomingCallPollingHandler {
  final Ref _ref;
  final GlobalKey<NavigatorState> navigatorKey;

  Timer? _pollTimer;
  bool _isPolling = false;
  bool _isTicking = false;
  String? _lastHandledCallId;

  IncomingCallPollingHandler(this._ref, {required this.navigatorKey});

  void start() {
    if (_isPolling) return;
    _isPolling = true;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) => _poll());
    _poll();
    developer.log('IncomingCallPollingHandler started', name: 'Calls');
  }

  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _isPolling = false;
    _isTicking = false;
    developer.log('IncomingCallPollingHandler stopped', name: 'Calls');
  }

  Future<void> _poll() async {
    if (_isTicking) return;
    _isTicking = true;
    try {
      final callState = _ref.read(callControllerProvider);
      if (callState is InCall ||
          callState is OutgoingRinging ||
          callState is IncomingRinging) {
        return;
      }

      final history = await _ref
          .read(callsRepositoryProvider)
          .getCallHistory(limit: 5, offset: 0);

      for (final item in history.items) {
        if (item.status != CallStatus.ringing || item.isInitiator) {
          continue;
        }

        if (_lastHandledCallId == item.callId) {
          break;
        }

        _lastHandledCallId = item.callId;
        await _handleIncomingCall(
          callId: item.callId,
          callType: item.callType,
          callerName: item.otherParticipant.name,
          callerUserId: item.otherParticipant.userId,
          callerAvatar: item.otherParticipant.avatar,
        );
        break;
      }
    } catch (e) {
      developer.log('Incoming call polling error: $e', name: 'Calls');
    } finally {
      _isTicking = false;
    }
  }

  Future<void> _handleIncomingCall({
    required String callId,
    required CallType callType,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
  }) async {
    _ref.read(callControllerProvider.notifier).handleIncomingCall(
          callId: callId,
          callType: callType,
          callerName: callerName,
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
        );

    final state = _ref.read(callControllerProvider);
    if (state is IncomingRinging && state.callId == callId) {
      // Use navigation guard to prevent duplicate screens
      final guard = _ref.read(callNavigationGuardProvider(navigatorKey));
      guard.showIncomingCallScreen(
        callId: callId,
        callType: callType,
        callerName: callerName,
        callerUserId: callerUserId,
        callerAvatar: callerAvatar,
      );
    }
  }

  void dispose() {
    stop();
  }
}

final incomingCallPollingHandlerProvider =
    Provider.family<IncomingCallPollingHandler, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final handler = IncomingCallPollingHandler(ref, navigatorKey: navigatorKey);
  ref.onDispose(() => handler.dispose());
  return handler;
});
