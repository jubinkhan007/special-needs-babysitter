/// DTO for token refresh response
class CallTokenDto {
  final String rtcToken;
  final String channelName;
  final String expiresAt;

  const CallTokenDto({
    required this.rtcToken,
    required this.channelName,
    required this.expiresAt,
  });

  factory CallTokenDto.fromJson(Map<String, dynamic> json) {
    return CallTokenDto(
      rtcToken: json['rtcToken'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }
}
