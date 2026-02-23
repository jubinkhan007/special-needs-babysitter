/// DTO for call participant
class CallParticipantDto {
  final String userId;
  final String name;
  final String? avatar;
  final String role;

  const CallParticipantDto({
    required this.userId,
    required this.name,
    this.avatar,
    required this.role,
  });

  factory CallParticipantDto.fromJson(Map<String, dynamic> json) {
    return CallParticipantDto(
      userId: json['userId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ??
            '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      avatar: json['avatar'] as String? ??
              json['avatarUrl'] as String? ??
              json['profilePhoto'] as String?,
      role: json['role'] as String? ?? 'parent',
    );
  }
}
