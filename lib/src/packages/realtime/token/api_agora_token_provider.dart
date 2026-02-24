import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import 'agora_token_provider.dart';

/// API-backed token provider that fetches tokens from the backend
class ApiAgoraTokenProvider implements AgoraTokenProvider {
  final Dio _dio;

  ApiAgoraTokenProvider(this._dio);

  @override
  Future<String?> getRtmToken(String userId) async {
    try {
      final response = await _dio.get('/chat/rtm-token');
      final data = response.data;
      final token = data['data']?['token'] as String?;

      developer.log(
        'RTM token fetched, length: ${token?.length ?? 0}',
        name: 'Realtime',
      );
      return token;
    } catch (e) {
      developer.log('Failed to fetch RTM token: $e', name: 'Realtime');
      // Return null to allow fallback to tokenless mode
      return null;
    }
  }

  @override
  Future<String?> getRtcToken(String channelName, int uid) async {
    // RTC tokens are provided by the call API endpoints
    // (initiateCall, acceptCall, refreshToken)
    // This is only a fallback and shouldn't be needed
    developer.log(
      'getRtcToken called as fallback — call API should provide tokens',
      name: 'Realtime',
    );
    return null;
  }
}
