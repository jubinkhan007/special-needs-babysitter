import '../entities/call_session.dart';
import '../repositories/calls_repository.dart';

class RefreshCallTokenUseCase {
  final CallsRepository _repository;

  RefreshCallTokenUseCase(this._repository);

  Future<CallTokenRefresh> call(String callId) {
    return _repository.refreshToken(callId);
  }
}
