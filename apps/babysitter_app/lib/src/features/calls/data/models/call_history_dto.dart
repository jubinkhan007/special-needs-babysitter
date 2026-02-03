import 'call_participant_dto.dart';

/// DTO for call history item
class CallHistoryItemDto {
  final String callId;
  final String callType;
  final String status;
  final bool isInitiator;
  final CallParticipantDto otherParticipant;
  final String? createdAt;
  final String? startedAt;
  final String? endedAt;
  final int? duration;

  const CallHistoryItemDto({
    required this.callId,
    required this.callType,
    required this.status,
    required this.isInitiator,
    required this.otherParticipant,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  factory CallHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return CallHistoryItemDto(
      callId: json['callId'] as String? ?? json['id'] as String? ?? '',
      callType: json['callType'] as String? ?? 'audio',
      status: json['status'] as String? ?? 'ended',
      isInitiator: json['isInitiator'] as bool? ?? false,
      otherParticipant: CallParticipantDto.fromJson(
        json['otherParticipant'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: json['createdAt'] as String?,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      duration: json['duration'] as int?,
    );
  }
}

/// DTO for paginated call history response
class CallHistoryResponseDto {
  final List<CallHistoryItemDto> calls;
  final int total;
  final int limit;
  final int offset;

  const CallHistoryResponseDto({
    required this.calls,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory CallHistoryResponseDto.fromJson(Map<String, dynamic> json) {
    final callsList = (json['calls'] as List<dynamic>?)
            ?.map((e) => CallHistoryItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return CallHistoryResponseDto(
      calls: callsList,
      total: pagination['total'] as int? ?? callsList.length,
      limit: pagination['limit'] as int? ?? 20,
      offset: pagination['offset'] as int? ?? 0,
    );
  }
}
