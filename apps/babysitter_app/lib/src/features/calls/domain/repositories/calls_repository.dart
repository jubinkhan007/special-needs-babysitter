import '../entities/call_config.dart';
import '../entities/call_session.dart';
import '../entities/call_history_item.dart';
import '../entities/call_enums.dart';

/// Repository interface for call operations
abstract interface class CallsRepository {
  /// GET /calls/config - Get Agora App ID
  Future<CallConfig> getCallConfig();

  /// POST /calls/initiate - Parent initiates call to sitter
  Future<CallSession> initiateCall({
    required String recipientUserId,
    required CallType callType,
  });

  /// POST /calls/{callId}/accept - Sitter accepts incoming call
  Future<CallSession> acceptCall(String callId);

  /// POST /calls/{callId}/decline - Sitter declines incoming call
  Future<void> declineCall(String callId, {String? reason});

  /// POST /calls/{callId}/end - Either participant ends call
  Future<void> endCall(String callId);

  /// GET /calls/{callId} - Get call details
  Future<CallSession> getCallDetails(String callId);

  /// POST /calls/{callId}/token - Refresh RTC token
  Future<CallTokenRefresh> refreshToken(String callId);

  /// GET /calls/history - Get call history with pagination
  Future<CallHistoryPage> getCallHistory({
    int limit = 20,
    int offset = 0,
  });
}
