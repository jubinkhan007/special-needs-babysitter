import 'call_enums.dart';
import 'call_participant.dart';

/// Represents an active or historical call session
class CallSession {
  final String callId;
  final String channelName;
  final String? rtcToken;
  final DateTime? tokenExpiresAt;
  final CallStatus status;
  final CallType callType;
  final CallParticipant? initiator;
  final CallParticipant? recipient;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;

  const CallSession({
    required this.callId,
    required this.channelName,
    this.rtcToken,
    this.tokenExpiresAt,
    required this.status,
    required this.callType,
    this.initiator,
    this.recipient,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  /// Check if current user is the initiator
  bool isInitiator(String currentUserId) => initiator?.userId == currentUserId;

  /// Get the remote participant (the other person in the call)
  CallParticipant? getRemoteParticipant(String currentUserId) {
    if (initiator?.userId == currentUserId) return recipient;
    return initiator;
  }

  CallSession copyWith({
    String? callId,
    String? channelName,
    String? rtcToken,
    DateTime? tokenExpiresAt,
    CallStatus? status,
    CallType? callType,
    CallParticipant? initiator,
    CallParticipant? recipient,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
  }) {
    return CallSession(
      callId: callId ?? this.callId,
      channelName: channelName ?? this.channelName,
      rtcToken: rtcToken ?? this.rtcToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      status: status ?? this.status,
      callType: callType ?? this.callType,
      initiator: initiator ?? this.initiator,
      recipient: recipient ?? this.recipient,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
    );
  }
}

/// Token refresh response
class CallTokenRefresh {
  final String rtcToken;
  final String channelName;
  final DateTime expiresAt;

  const CallTokenRefresh({
    required this.rtcToken,
    required this.channelName,
    required this.expiresAt,
  });
}
