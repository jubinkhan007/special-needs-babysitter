import 'dart:developer' as developer;

import 'package:core/core.dart';

import 'agora_token_provider.dart';

/// Environment-based token provider
/// Returns null tokens for dev mode (token-less development)
/// In production, replace with API-backed implementation
class EnvAgoraTokenProvider implements AgoraTokenProvider {
  @override
  Future<String?> getRtmToken(String userId) async {
    // Check if token server is configured
    if (!EnvConfig.hasAgoraTokenServer) {
      developer.log(
        'No token server configured, using null token for RTM (dev mode)',
        name: 'Realtime',
      );
      return null;
    }

    // TODO: Implement token server call when AGORA_TOKEN_SERVER_URL is set
    // final url = '${EnvConfig.agoraTokenServerUrl}/rtm/$userId';
    // final response = await dio.get(url);
    // return response.data['token'];

    developer.log(
      'Token server configured but not implemented, using null token',
      name: 'Realtime',
    );
    return null;
  }

  @override
  Future<String?> getRtcToken(String channelName, int uid) async {
    // Check if token server is configured
    if (!EnvConfig.hasAgoraTokenServer) {
      developer.log(
        'No token server configured, using null token for RTC (dev mode)',
        name: 'Realtime',
      );
      return null;
    }

    // TODO: Implement token server call when AGORA_TOKEN_SERVER_URL is set
    // final url = '${EnvConfig.agoraTokenServerUrl}/rtc/$channelName/$uid';
    // final response = await dio.get(url);
    // return response.data['token'];

    developer.log(
      'Token server configured but not implemented, using null token',
      name: 'Realtime',
    );
    return null;
  }
}
