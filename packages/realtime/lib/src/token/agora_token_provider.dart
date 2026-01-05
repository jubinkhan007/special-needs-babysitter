/// Interface for providing Agora tokens
/// Allows switching between dev mode (null tokens) and production (server-generated)
abstract interface class AgoraTokenProvider {
  /// Get RTM token for user
  /// Returns null for dev/token-less mode
  Future<String?> getRtmToken(String userId);

  /// Get RTC token for channel
  /// Returns null for dev/token-less mode
  Future<String?> getRtcToken(String channelName, int uid);
}
