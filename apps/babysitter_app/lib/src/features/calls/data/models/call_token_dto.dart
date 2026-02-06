/// DTO for token refresh response
class CallTokenDto {
  final String rtcToken;
  final String channelName;
  final String expiresAt;
  /// UID that the token was generated for (must use this UID when joining)
  final int? agoraUid;

  const CallTokenDto({
    required this.rtcToken,
    required this.channelName,
    required this.expiresAt,
    this.agoraUid,
  });

  factory CallTokenDto.fromJson(Map<String, dynamic> json) {
    return CallTokenDto(
      rtcToken: json['rtcToken'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
      // Parse agoraUid - backend may return it as int or string
      agoraUid: json['agoraUid'] != null
          ? (json['agoraUid'] is int
              ? json['agoraUid'] as int
              : int.tryParse(json['agoraUid'].toString()))
          : (json['uid'] != null
              ? (json['uid'] is int
                  ? json['uid'] as int
                  : int.tryParse(json['uid'].toString()))
              : null),
    );
  }
}
