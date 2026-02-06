import 'package:flutter/foundation.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_enums.dart';

/// Sealed class representing all possible call states
@immutable
sealed class CallState {
  const CallState();
}

/// Idle state - no active call
class CallIdle extends CallState {
  const CallIdle();
}

/// Loading state - transitioning between states
class CallLoading extends CallState {
  final String message;
  const CallLoading([this.message = 'Loading...']);
}

/// Outgoing call ringing - waiting for recipient to answer
class OutgoingRinging extends CallState {
  final CallSession session;
  const OutgoingRinging(this.session);
}

/// Incoming call ringing - received call, waiting for user action
class IncomingRinging extends CallState {
  final String callId;
  final CallType callType;
  final CallParticipant caller;
  final CallSession? fullSession; // Lazy loaded from backend

  const IncomingRinging({
    required this.callId,
    required this.callType,
    required this.caller,
    this.fullSession,
  });

  IncomingRinging withSession(CallSession session) {
    return IncomingRinging(
      callId: callId,
      callType: callType,
      caller: caller,
      fullSession: session,
    );
  }
}

/// Active call in progress
class InCall extends CallState {
  final CallSession session;
  final bool isAudioMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final bool isFrontCamera;
  final int? remoteUid;
  final bool remoteJoined;
  final bool remoteVideoMuted;
  final int elapsedSeconds;

  const InCall({
    required this.session,
    this.isAudioMuted = false,
    this.isVideoEnabled = true,
    this.isSpeakerOn = false,
    this.isFrontCamera = true,
    this.remoteUid,
    this.remoteJoined = false,
    this.remoteVideoMuted = false,
    this.elapsedSeconds = 0,
  });

  InCall copyWith({
    CallSession? session,
    bool? isAudioMuted,
    bool? isVideoEnabled,
    bool? isSpeakerOn,
    bool? isFrontCamera,
    int? remoteUid,
    bool? remoteJoined,
    bool? remoteVideoMuted,
    int? elapsedSeconds,
  }) {
    return InCall(
      session: session ?? this.session,
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      remoteUid: remoteUid ?? this.remoteUid,
      remoteJoined: remoteJoined ?? this.remoteJoined,
      remoteVideoMuted: remoteVideoMuted ?? this.remoteVideoMuted,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

/// Call ended state
class CallEnded extends CallState {
  final String callId;
  final CallEndReason reason;
  final int? duration;

  const CallEnded({
    required this.callId,
    required this.reason,
    this.duration,
  });
}

/// Call error state
class CallError extends CallState {
  final String message;
  final String? code;

  const CallError({
    required this.message,
    this.code,
  });
}

/// Reason for call ending
enum CallEndReason {
  userEnded,       // Current user ended the call
  remoteEnded,     // Remote participant ended/left
  declined,        // Call was declined
  missed,          // Call timed out with no answer
  cancelled,       // Caller cancelled before answer
  error,           // Technical error
  busy,            // Recipient was busy
}
