import '../entities/call_session.dart';
import '../repositories/calls_repository.dart';

class AcceptCallUseCase {
  final CallsRepository _repository;

  AcceptCallUseCase(this._repository);

  Future<CallSession> call(String callId) {
    return _repository.acceptCall(callId);
  }
}
