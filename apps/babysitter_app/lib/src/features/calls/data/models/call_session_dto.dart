import 'call_participant_dto.dart';

/// DTO for call session response
class CallSessionDto {
  final String callId;
  final String channelName;
  final String? rtcToken;
  final String? tokenExpiresAt;
  final String status;
  final String callType;
  final CallParticipantDto? initiator;
  final CallParticipantDto? recipient;
  final CallParticipantDto? user;
  final String? createdAt;
  final String? startedAt;
  final String? endedAt;
  final int? duration;

  const CallSessionDto({
    required this.callId,
    required this.channelName,
    this.rtcToken,
    this.tokenExpiresAt,
    required this.status,
    required this.callType,
    this.initiator,
    this.recipient,
    this.user,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  factory CallSessionDto.fromJson(Map<String, dynamic> json) {
    return CallSessionDto(
      callId: json['callId'] as String? ?? json['id'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      rtcToken: json['rtcToken'] as String?,
      tokenExpiresAt: json['tokenExpiresAt'] as String?,
      status: json['status'] as String? ?? 'unknown',
      callType: json['callType'] as String? ?? 'audio',
      initiator: json['initiator'] != null
          ? CallParticipantDto.fromJson(json['initiator'] as Map<String, dynamic>)
          : null,
      recipient: json['recipient'] != null
          ? CallParticipantDto.fromJson(json['recipient'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? CallParticipantDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      duration: json['duration'] as int?,
    );
  }
}
