import 'call_enums.dart';
import 'call_participant.dart';

/// Represents a call in history
class CallHistoryItem {
  final String callId;
  final CallType callType;
  final CallStatus status;
  final bool isInitiator;
  final CallParticipant otherParticipant;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;

  const CallHistoryItem({
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

  /// Format duration as MM:SS
  String get durationFormatted {
    if (duration == null || duration! <= 0) return '--:--';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if this was a missed call
  bool get wasMissed =>
      status == CallStatus.missed ||
      (status == CallStatus.ended && startedAt == null);
}

/// Paginated call history response
class CallHistoryPage {
  final List<CallHistoryItem> items;
  final int total;
  final int limit;
  final int offset;

  const CallHistoryPage({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + items.length < total;
  int get nextOffset => offset + items.length;
}
