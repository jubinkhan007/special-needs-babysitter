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
      duration: _parseIntOrNull(json['duration']),
    );
  }
}

/// Safely parse an int from dynamic value (handles both int and String)
int? _parseIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

/// Safely parse an int with a default value
int _parseIntOrDefault(dynamic value, int defaultValue) {
  return _parseIntOrNull(value) ?? defaultValue;
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
      total: _parseIntOrDefault(pagination['total'], callsList.length),
      limit: _parseIntOrDefault(pagination['limit'], 20),
      offset: _parseIntOrDefault(pagination['offset'], 0),
    );
  }
}
