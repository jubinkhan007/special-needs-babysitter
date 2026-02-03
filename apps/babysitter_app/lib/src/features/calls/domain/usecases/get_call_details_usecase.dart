import '../entities/call_session.dart';
import '../repositories/calls_repository.dart';

class GetCallDetailsUseCase {
  final CallsRepository _repository;

  GetCallDetailsUseCase(this._repository);

  Future<CallSession> call(String callId) {
    return _repository.getCallDetails(callId);
  }
}
