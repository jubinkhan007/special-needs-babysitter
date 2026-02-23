/// DTO for /calls/config response
class CallConfigDto {
  final String appId;

  const CallConfigDto({required this.appId});

  factory CallConfigDto.fromJson(Map<String, dynamic> json) {
    return CallConfigDto(
      appId: json['appId'] as String? ?? '',
    );
  }
}
