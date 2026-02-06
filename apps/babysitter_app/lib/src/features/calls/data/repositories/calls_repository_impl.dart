import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_history_item.dart';
import '../../domain/entities/call_enums.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/repositories/calls_repository.dart';
import '../datasources/calls_remote_data_source.dart';
import '../models/call_session_dto.dart';
import '../models/call_participant_dto.dart';
import '../models/call_history_dto.dart';

/// Implementation of CallsRepository
class CallsRepositoryImpl implements CallsRepository {
  final CallsRemoteDataSource _remoteDataSource;

  CallsRepositoryImpl(this._remoteDataSource);

  @override
  Future<CallConfig> getCallConfig() async {
    final dto = await _remoteDataSource.getCallConfig();
    return CallConfig(appId: dto.appId);
  }

  @override
  Future<CallSession> initiateCall({
    required String recipientUserId,
    required CallType callType,
  }) async {
    final dto = await _remoteDataSource.initiateCall(
      recipientUserId: recipientUserId,
      callType: callType.name,
    );
    return _mapSessionFromDto(dto);
  }

  @override
  Future<CallSession> acceptCall(String callId) async {
    final dto = await _remoteDataSource.acceptCall(callId);
    return _mapSessionFromDto(dto);
  }

  @override
  Future<void> declineCall(String callId, {String? reason}) async {
    await _remoteDataSource.declineCall(callId, reason: reason);
  }

  @override
  Future<void> endCall(String callId) async {
    await _remoteDataSource.endCall(callId);
  }

  @override
  Future<CallSession> getCallDetails(String callId) async {
    final dto = await _remoteDataSource.getCallDetails(callId);
    return _mapSessionFromDto(dto);
  }

  @override
  Future<CallTokenRefresh> refreshToken(String callId) async {
    final dto = await _remoteDataSource.refreshToken(callId);
    return CallTokenRefresh(
      rtcToken: dto.rtcToken,
      channelName: dto.channelName,
      expiresAt: DateTime.tryParse(dto.expiresAt) ?? DateTime.now().add(const Duration(hours: 1)),
      agoraUid: dto.agoraUid,
    );
  }

  @override
  Future<CallHistoryPage> getCallHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    final dto = await _remoteDataSource.getCallHistory(
      limit: limit,
      offset: offset,
    );
    return CallHistoryPage(
      items: dto.calls.map(_mapHistoryItemFromDto).toList(),
      total: dto.total,
      limit: dto.limit,
      offset: dto.offset,
    );
  }

  // ==================== Mappers ====================

  CallSession _mapSessionFromDto(CallSessionDto dto) {
    return CallSession(
      callId: dto.callId,
      channelName: dto.channelName,
      rtcToken: dto.rtcToken,
      tokenExpiresAt: dto.tokenExpiresAt != null
          ? DateTime.tryParse(dto.tokenExpiresAt!)
          : null,
      status: CallStatus.fromString(dto.status),
      callType: CallType.fromString(dto.callType),
      initiator: dto.initiator != null
          ? _mapParticipantFromDto(dto.initiator!)
          : null,
      recipient: dto.recipient != null
          ? _mapParticipantFromDto(dto.recipient!)
          : null,
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      startedAt: dto.startedAt != null
          ? DateTime.tryParse(dto.startedAt!)
          : null,
      endedAt: dto.endedAt != null
          ? DateTime.tryParse(dto.endedAt!)
          : null,
      duration: dto.duration,
      agoraUid: dto.agoraUid,
    );
  }

  CallParticipant _mapParticipantFromDto(CallParticipantDto dto) {
    return CallParticipant(
      userId: dto.userId,
      name: dto.name.isNotEmpty ? dto.name : 'Unknown',
      avatar: dto.avatar,
      role: UserRole.fromString(dto.role),
    );
  }

  CallHistoryItem _mapHistoryItemFromDto(CallHistoryItemDto dto) {
    return CallHistoryItem(
      callId: dto.callId,
      callType: CallType.fromString(dto.callType),
      status: CallStatus.fromString(dto.status),
      isInitiator: dto.isInitiator,
      otherParticipant: _mapParticipantFromDto(dto.otherParticipant),
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      startedAt: dto.startedAt != null
          ? DateTime.tryParse(dto.startedAt!)
          : null,
      endedAt: dto.endedAt != null
          ? DateTime.tryParse(dto.endedAt!)
          : null,
      duration: dto.duration,
    );
  }
}
