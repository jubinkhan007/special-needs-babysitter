import 'call_enums.dart';

/// Represents a participant in a call
class CallParticipant {
  final String userId;
  final String name;
  final String? avatar;
  final UserRole role;

  const CallParticipant({
    required this.userId,
    required this.name,
    this.avatar,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallParticipant && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
