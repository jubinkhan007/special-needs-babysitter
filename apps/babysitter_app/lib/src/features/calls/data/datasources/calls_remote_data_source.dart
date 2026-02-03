import 'dart:developer' as developer;
import 'package:dio/dio.dart';

import '../models/call_config_dto.dart';
import '../models/call_session_dto.dart';
import '../models/call_history_dto.dart';
import '../models/call_token_dto.dart';

/// Interface for calls API operations
abstract interface class CallsRemoteDataSource {
  /// GET /calls/config - Get Agora App ID
  Future<CallConfigDto> getCallConfig();

  /// POST /calls/initiate - Parent initiates call to sitter
  Future<CallSessionDto> initiateCall({
    required String recipientUserId,
    required String callType,
  });

  /// POST /calls/{callId}/accept - Sitter accepts incoming call
  Future<CallSessionDto> acceptCall(String callId);

  /// POST /calls/{callId}/decline - Sitter declines incoming call
  Future<void> declineCall(String callId, {String? reason});

  /// POST /calls/{callId}/end - Either participant ends call
  Future<void> endCall(String callId);

  /// GET /calls/{callId} - Get call details
  Future<CallSessionDto> getCallDetails(String callId);

  /// POST /calls/{callId}/token - Refresh RTC token
  Future<CallTokenDto> refreshToken(String callId);

  /// GET /calls/history - Get call history with pagination
  Future<CallHistoryResponseDto> getCallHistory({
    int limit = 20,
    int offset = 0,
  });
}

/// Implementation of CallsRemoteDataSource using Dio
class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final Dio _dio;

  CallsRemoteDataSourceImpl(this._dio);

  @override
  Future<CallConfigDto> getCallConfig() async {
    try {
      developer.log('CallsRemoteDataSource.getCallConfig()', name: 'Calls');
      final response = await _dio.get('/calls/config');

      final data = _extractData(response.data);
      return CallConfigDto.fromJson(data);
    } catch (e, stack) {
      _logError('getCallConfig', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> initiateCall({
    required String recipientUserId,
    required String callType,
  }) async {
    try {
      developer.log(
        'CallsRemoteDataSource.initiateCall($recipientUserId, $callType)',
        name: 'Calls',
      );
      final response = await _dio.post(
        '/calls/initiate',
        data: {
          'recipientUserId': recipientUserId,
          'callType': callType,
        },
      );

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('initiateCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> acceptCall(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.acceptCall($callId)', name: 'Calls');
      final response = await _dio.post(
        '/calls/$callId/accept',
        data: {'callId': callId}, // Some backends expect body too
      );

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('acceptCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> declineCall(String callId, {String? reason}) async {
    try {
      developer.log('CallsRemoteDataSource.declineCall($callId)', name: 'Calls');
      await _dio.post(
        '/calls/$callId/decline',
        data: {
          'callId': callId,
          if (reason != null) 'reason': reason,
        },
      );
    } catch (e, stack) {
      _logError('declineCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> endCall(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.endCall($callId)', name: 'Calls');
      await _dio.post(
        '/calls/$callId/end',
        data: {'callId': callId},
      );
    } catch (e, stack) {
      _logError('endCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> getCallDetails(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.getCallDetails($callId)', name: 'Calls');
      final response = await _dio.get('/calls/$callId');

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('getCallDetails', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallTokenDto> refreshToken(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.refreshToken($callId)', name: 'Calls');
      final response = await _dio.post('/calls/$callId/token');

      final data = _extractData(response.data);
      return CallTokenDto.fromJson(data);
    } catch (e, stack) {
      _logError('refreshToken', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallHistoryResponseDto> getCallHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      developer.log(
        'CallsRemoteDataSource.getCallHistory(limit: $limit, offset: $offset)',
        name: 'Calls',
      );
      final response = await _dio.get(
        '/calls/history',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      final data = _extractData(response.data);
      return CallHistoryResponseDto.fromJson(data);
    } catch (e, stack) {
      if (e is DioException && e.response?.statusCode == 404) {
        developer.log(
          'Call history not found (404). Returning empty history.',
          name: 'Calls',
        );
        return CallHistoryResponseDto(
          calls: const [],
          total: 0,
          limit: limit,
          offset: offset,
        );
      }
      _logError('getCallHistory', e, stack);
      rethrow;
    }
  }

  /// Extract data field from API response, handling various formats
  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData == null) {
      return {};
    }
    if (responseData is Map<String, dynamic>) {
      // Handle nested data field (common API pattern)
      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        return data is Map<String, dynamic> ? data : responseData;
      }
      return responseData;
    }
    return {};
  }

  void _logError(String method, Object e, StackTrace stack) {
    developer.log('Error in $method: $e', name: 'Calls');
    developer.log('Stack trace: $stack', name: 'Calls');
    if (e is DioException) {
      developer.log('Dio Response: ${e.response?.data}', name: 'Calls');
    }
  }
}
