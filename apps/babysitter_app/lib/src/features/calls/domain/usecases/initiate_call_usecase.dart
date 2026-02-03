import '../entities/call_session.dart';
import '../entities/call_enums.dart';
import '../repositories/calls_repository.dart';

class InitiateCallParams {
  final String recipientUserId;
  final CallType callType;

  const InitiateCallParams({
    required this.recipientUserId,
    required this.callType,
  });
}

class InitiateCallUseCase {
  final CallsRepository _repository;

  InitiateCallUseCase(this._repository);

  Future<CallSession> call(InitiateCallParams params) {
    return _repository.initiateCall(
      recipientUserId: params.recipientUserId,
      callType: params.callType,
    );
  }
}
