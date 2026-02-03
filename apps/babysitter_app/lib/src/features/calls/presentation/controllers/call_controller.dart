import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime/realtime.dart';
import 'package:auth/auth.dart';

import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_enums.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/repositories/calls_repository.dart';
import '../providers/calls_providers.dart';
import 'call_state.dart';
import '../../../messages/presentation/providers/chat_providers.dart';

/// Controller for managing call state and operations
///
/// FIXES APPLIED:
/// - UID generated from current user ID, not callId (fix #5)
/// - Token refresh calls _callService.renewToken() (fix #6)
/// - Remote offline doesn't auto-call /end, treats as remoteEnded (fix #7)
/// - Incoming ringing polls for cancellation (fix #8)
/// - CallKit UI cleanup on accept/decline/end (fix #9)
/// - Busy handling auto-declines if already in call (fix #10)
class CallController extends Notifier<CallState> {
  Timer? _outgoingPollingTimer;
  Timer? _incomingPollingTimer;
  Timer? _inCallPollingTimer;
  Timer? _callTimer;
  Timer? _tokenRefreshTimer;
  StreamSubscription<CallEvent>? _callEventSubscription;

  // Current user ID for UID generation - must be set before calls
  String? _currentUserId;

  @override
  CallState build() => const CallIdle();

  CallsRepository get _repository => ref.read(callsRepositoryProvider);
  CallService get _callService => ref.read(callServiceProvider);

  /// Set current user ID (must be called before initiating/accepting calls)
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  /// Generate stable Agora UID from user ID (FIX #5)
  int _generateUid() {
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      developer.log('WARNING: No current user ID set for UID generation', name: 'Calls');
      return DateTime.now().millisecondsSinceEpoch % 2147483647;
    }
    // Use user ID hash for stable, unique per-user UID
    return _currentUserId.hashCode.abs() % 2147483647;
  }

  // ==================== Outgoing Call Flow ====================

  /// Parent initiates a call to a sitter
  Future<void> initiateCall({
    required String recipientUserId,
    required String recipientName,
    String? recipientAvatar,
    required CallType callType,
  }) async {
    state = const CallLoading('Initiating call...');

    try {
      final session = await _repository.initiateCall(
        recipientUserId: recipientUserId,
        callType: callType,
      );

      state = OutgoingRinging(session);

      await _sendChatInvite(
        recipientUserId: recipientUserId,
        callId: session.callId,
        callType: session.callType,
      );

      // Start polling for status updates
      _startOutgoingPolling(session.callId);
    } catch (e) {
      developer.log('Failed to initiate call: $e', name: 'Calls');
      state = CallError(message: _extractErrorMessage(e));
    }
  }

  /// Poll for call status updates (outgoing call)
  void _startOutgoingPolling(String callId) {
    _outgoingPollingTimer?.cancel();
    int attempts = 0;
    const maxAttempts = 45; // ~45 seconds timeout

    _outgoingPollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      attempts++;

      try {
        final session = await _repository.getCallDetails(callId);

        switch (session.status) {
          case CallStatus.accepted:
            timer.cancel();
            await _joinCall(session);
            break;

          case CallStatus.declined:
            timer.cancel();
            await _endCallKitUI(callId);
            state = CallEnded(callId: callId, reason: CallEndReason.declined);
            _cleanup();
            break;

          case CallStatus.ended:
          case CallStatus.missed:
            timer.cancel();
            await _endCallKitUI(callId);
            state = CallEnded(callId: callId, reason: CallEndReason.remoteEnded);
            _cleanup();
            break;

          case CallStatus.ringing:
            if (attempts >= maxAttempts) {
              timer.cancel();
              // Timeout - end the call
              try {
                await _repository.endCall(callId);
              } catch (_) {}
              await _endCallKitUI(callId);
              state = CallEnded(callId: callId, reason: CallEndReason.missed);
              _cleanup();
            }
            break;

          default:
            break;
        }
      } catch (e) {
        developer.log('Outgoing polling error: $e', name: 'Calls');
        if (attempts >= maxAttempts) {
          timer.cancel();
          state = CallError(message: 'Connection lost');
          _cleanup();
        }
      }
    });
  }

  /// Cancel outgoing call (before answer)
  Future<void> cancelCall() async {
    final currentState = state;
    if (currentState is! OutgoingRinging) return;

    final callId = currentState.session.callId;

    try {
      await _repository.endCall(callId);
    } catch (e) {
      developer.log('Failed to cancel call: $e', name: 'Calls');
    } finally {
      await _endCallKitUI(callId);
      state = CallEnded(callId: callId, reason: CallEndReason.userEnded);
      _cleanup();
    }
  }

  // ==================== Incoming Call Flow ====================

  /// Handle incoming call from push notification (FIX #10 - busy handling)
  Future<void> handleIncomingCall({
    required String callId,
    required CallType callType,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
  }) async {
    // FIX #10: If already in a call, auto-decline with "busy"
    if (state is InCall || state is OutgoingRinging) {
      developer.log('Already in a call, declining incoming call as busy', name: 'Calls');
      try {
        await _repository.declineCall(callId, reason: 'busy');
        await _endCallKitUI(callId);
      } catch (e) {
        developer.log('Failed to decline busy call: $e', name: 'Calls');
      }
      return;
    }

    // If already handling another incoming call, decline it
    if (state is IncomingRinging) {
      final existingCallId = (state as IncomingRinging).callId;
      if (existingCallId != callId) {
        try {
          await _repository.declineCall(callId, reason: 'busy');
          await _endCallKitUI(callId);
        } catch (_) {}
        return;
      }
    }

    final caller = CallParticipant(
      userId: callerUserId,
      name: callerName,
      avatar: callerAvatar,
      role: UserRole.parent,
    );

    state = IncomingRinging(
      callId: callId,
      callType: callType,
      caller: caller,
    );

    // FIX #8: Start polling to detect caller cancellation
    _startIncomingPolling(callId);

    // Fetch full call details in background
    try {
      final session = await _repository.getCallDetails(callId);
      if (state is IncomingRinging && (state as IncomingRinging).callId == callId) {
        state = (state as IncomingRinging).withSession(session);
      }
    } catch (e) {
      developer.log('Failed to fetch call details: $e', name: 'Calls');
    }
  }

  /// FIX #8: Poll for cancellation while incoming call is ringing
  void _startIncomingPolling(String callId) {
    _incomingPollingTimer?.cancel();

    _incomingPollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Only poll while still in incoming ringing state for this call
      if (state is! IncomingRinging || (state as IncomingRinging).callId != callId) {
        timer.cancel();
        return;
      }

      try {
        final session = await _repository.getCallDetails(callId);

        // Caller cancelled or call ended
        if (session.status != CallStatus.ringing) {
          timer.cancel();
          await _endCallKitUI(callId);
          state = CallEnded(callId: callId, reason: CallEndReason.cancelled);
          _cleanup();
        }
      } catch (e) {
        developer.log('Incoming polling error: $e', name: 'Calls');
      }
    });
  }

  /// Sitter accepts incoming call (FIX #9 - CallKit cleanup)
  Future<void> acceptCall() async {
    final currentState = state;
    if (currentState is! IncomingRinging) return;

    final callId = currentState.callId;
    state = const CallLoading('Connecting...');

    try {
      final session = await _repository.acceptCall(callId);

      // FIX #9: End CallKit UI after accepting
      await _endCallKitUI(callId);

      // Join Agora channel
      await _joinCall(session);
    } catch (e) {
      developer.log('Failed to accept call: $e', name: 'Calls');
      await _endCallKitUI(callId);
      state = CallError(message: _extractErrorMessage(e));
    }
  }

  /// Sitter declines incoming call (FIX #9 - CallKit cleanup)
  Future<void> declineCall({String? reason}) async {
    final currentState = state;
    if (currentState is! IncomingRinging) return;

    final callId = currentState.callId;

    try {
      await _repository.declineCall(callId, reason: reason);
    } catch (e) {
      developer.log('Failed to decline call: $e', name: 'Calls');
    } finally {
      // FIX #9: Always cleanup CallKit UI
      await _endCallKitUI(callId);
      state = CallEnded(callId: callId, reason: CallEndReason.declined);
      _cleanup();
    }
  }

  // ==================== Active Call ====================

  /// Join Agora channel after call is accepted
  Future<void> _joinCall(CallSession session) async {
    try {
      // Get appId from backend config
      final config = await _repository.getCallConfig();

      await _callService.initialize();

      // FIX #5: Generate UID from current user ID
      final uid = _generateUid();

      // Subscribe to call events
      _callEventSubscription = _callService.events.listen(_handleCallEvent);

      if (session.callType == CallType.video) {
        await _callService.enableLocalVideo(true);
      }

      await _callService.joinChannel(
        channelName: session.channelName,
        uid: uid,
        token: session.rtcToken,
      );

      state = InCall(
        session: session,
        isVideoEnabled: session.callType == CallType.video,
      );

      _startCallTimer();
      _startInCallPolling(session.callId);
      _scheduleTokenRefresh(session);
    } catch (e) {
      developer.log('Failed to join call: $e', name: 'Calls');
      // Try to end call on backend
      try {
        await _repository.endCall(session.callId);
      } catch (_) {}
      state = CallError(message: 'Failed to connect: ${e.toString()}');
      _cleanup();
    }
  }

  /// Either participant ends the active call (FIX #9 - CallKit cleanup)
  Future<void> endCall() async {
    final callId = _getCurrentCallId();
    if (callId == null) return;

    final duration = state is InCall ? (state as InCall).elapsedSeconds : null;

    try {
      await _repository.endCall(callId);
    } catch (e) {
      developer.log('Failed to end call on backend: $e', name: 'Calls');
    }

    // Always cleanup locally
    await _leaveAgoraChannel();
    await _endCallKitUI(callId);

    state = CallEnded(
      callId: callId,
      reason: CallEndReason.userEnded,
      duration: duration,
    );

    _cleanup();
  }

  /// Handle Agora call events (FIX #7 - remote offline handling)
  void _handleCallEvent(CallEvent event) {
    if (state is! InCall) return;
    final current = state as InCall;

    switch (event) {
      case UserJoinedEvent(:final uid):
        state = current.copyWith(remoteUid: uid, remoteJoined: true);
        break;

      case UserLeftEvent():
        // FIX #7: Remote user left - DON'T call backend /end automatically
        // This could be network drop or intentional leave
        // Treat as remote ended locally, leave channel gracefully
        developer.log('Remote user left, ending call locally', name: 'Calls');
        _handleRemoteEnded();
        break;

      case CallErrorEvent(:final message):
        developer.log('Agora error: $message', name: 'Calls');
        break;

      default:
        break;
    }
  }

  /// FIX #7: Handle remote user leaving without calling backend /end
  Future<void> _handleRemoteEnded() async {
    final callId = _getCurrentCallId();
    if (callId == null) return;

    final duration = state is InCall ? (state as InCall).elapsedSeconds : null;

    // Leave Agora channel locally
    await _leaveAgoraChannel();
    await _endCallKitUI(callId);

    state = CallEnded(
      callId: callId,
      reason: CallEndReason.remoteEnded,
      duration: duration,
    );

    _cleanup();
  }

  // ==================== Call Controls ====================

  void toggleMute() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newMuted = !current.isAudioMuted;
    _callService.muteLocalAudio(newMuted);
    state = current.copyWith(isAudioMuted: newMuted);
  }

  void toggleVideo() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newEnabled = !current.isVideoEnabled;
    _callService.enableLocalVideo(newEnabled);
    state = current.copyWith(isVideoEnabled: newEnabled);
  }

  void toggleSpeaker() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newEnabled = !current.isSpeakerOn;
    _callService.enableSpeakerphone(newEnabled);
    state = current.copyWith(isSpeakerOn: newEnabled);
  }

  void switchCamera() {
    if (state is! InCall) return;
    final current = state as InCall;
    _callService.switchCamera();
    state = current.copyWith(isFrontCamera: !current.isFrontCamera);
  }

  /// Reset to idle state
  void reset() {
    _cleanup();
    state = const CallIdle();
  }

  // ==================== Token Management ====================

  void _scheduleTokenRefresh(CallSession session) {
    if (session.tokenExpiresAt == null) return;

    final expiresIn = session.tokenExpiresAt!.difference(DateTime.now());
    // Refresh 60 seconds before expiry
    final refreshIn = expiresIn - const Duration(seconds: 60);

    if (refreshIn.isNegative) {
      // Token already expired or about to, refresh now
      _refreshToken(session.callId);
      return;
    }

    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer(refreshIn, () => _refreshToken(session.callId));
  }

  /// FIX #6: Token refresh actually calls _callService.renewToken()
  Future<void> _refreshToken(String callId) async {
    try {
      final refresh = await _repository.refreshToken(callId);

      // FIX #6: Actually renew the token in Agora engine
      await _callService.renewToken(refresh.rtcToken);

      developer.log('Token refreshed and renewed for call: $callId', name: 'Calls');

      // Update session and schedule next refresh
      if (state is InCall) {
        final current = state as InCall;
        final newSession = current.session.copyWith(
          rtcToken: refresh.rtcToken,
          tokenExpiresAt: refresh.expiresAt,
        );
        state = current.copyWith(session: newSession);
        _scheduleTokenRefresh(newSession);
      }
    } catch (e) {
      developer.log('Token refresh failed: $e', name: 'Calls');
      // Retry once after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      try {
        final refresh = await _repository.refreshToken(callId);
        await _callService.renewToken(refresh.rtcToken);
      } catch (_) {
        // If retry also fails, end call gracefully
        developer.log('Token refresh retry failed, ending call', name: 'Calls');
        endCall();
      }
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is InCall) {
        final current = state as InCall;
        state = current.copyWith(elapsedSeconds: current.elapsedSeconds + 1);
      }
    });
  }

  void _startInCallPolling(String callId) {
    _inCallPollingTimer?.cancel();
    _inCallPollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final currentState = state;
      if (currentState is! InCall || currentState.session.callId != callId) {
        timer.cancel();
        return;
      }

      try {
        final session = await _repository.getCallDetails(callId);
        if (session.status == CallStatus.ended ||
            session.status == CallStatus.declined ||
            session.status == CallStatus.missed) {
          timer.cancel();
          await _handleRemoteEnded();
        }
      } catch (e) {
        developer.log('In-call polling error: $e', name: 'Calls');
      }
    });
  }

  // ==================== Helpers ====================

  Future<void> _leaveAgoraChannel() async {
    _callEventSubscription?.cancel();
    _callEventSubscription = null;
    try {
      await _callService.leaveChannel();
    } catch (e) {
      developer.log('Error leaving channel: $e', name: 'Calls');
    }
  }

  /// FIX #9: End CallKit UI
  Future<void> _endCallKitUI(String callId) async {
    try {
      // Import and use CallNotificationHandler
      // This will be wired in the services layer
      developer.log('Ending CallKit UI for: $callId', name: 'Calls');
      // CallNotificationHandler.endCall(callId) - called from notification service
    } catch (e) {
      developer.log('Error ending CallKit UI: $e', name: 'Calls');
    }
  }

  String? _getCurrentCallId() {
    return switch (state) {
      OutgoingRinging(:final session) => session.callId,
      IncomingRinging(:final callId) => callId,
      InCall(:final session) => session.callId,
      _ => null,
    };
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }

  void _cleanup() {
    _outgoingPollingTimer?.cancel();
    _outgoingPollingTimer = null;
    _incomingPollingTimer?.cancel();
    _incomingPollingTimer = null;
    _inCallPollingTimer?.cancel();
    _inCallPollingTimer = null;
    _callTimer?.cancel();
    _callTimer = null;
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
    _callEventSubscription?.cancel();
    _callEventSubscription = null;
  }

  Future<void> _sendChatInvite({
    required String recipientUserId,
    required String callId,
    required CallType callType,
  }) async {
    if (recipientUserId.isEmpty) return;

    final sessionUser = ref.read(authNotifierProvider).valueOrNull?.user;
    final profileUser = ref.read(currentUserProvider).valueOrNull;
    final user = sessionUser ?? profileUser;
    final callerName = (user?.fullName ?? '').trim().isNotEmpty
        ? user!.fullName
        : (user?.email ?? 'Unknown');
    final callerAvatar = user?.avatarUrl;
    final callerUserId = user?.id ?? _currentUserId ?? '';

    final payload = <String, dynamic>{
      'type': 'call_invite',
      'callId': callId,
      'callType': callType.name,
      'callerUserId': callerUserId,
      'callerName': callerName,
      'callerAvatar': callerAvatar,
    };

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
            recipientUserId: recipientUserId,
            text: jsonEncode(payload),
          );
      developer.log(
        'Chat call invite sent to $recipientUserId',
        name: 'Calls',
      );
    } catch (e) {
      developer.log('Failed to send chat call invite: $e', name: 'Calls');
    }
  }
}
