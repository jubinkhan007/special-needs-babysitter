import 'package:babysitter_app/src/features/calls/domain/entities/call_session.dart';
import 'package:babysitter_app/src/features/calls/domain/repositories/calls_repository.dart';

class RefreshCallTokenUseCase {
  final CallsRepository _repository;

  RefreshCallTokenUseCase(this._repository);

  Future<CallTokenRefresh> call(String callId) {
    return _repository.refreshToken(callId);
  }
}
