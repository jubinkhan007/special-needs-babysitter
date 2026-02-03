import '../repositories/calls_repository.dart';

class DeclineCallParams {
  final String callId;
  final String? reason;

  const DeclineCallParams({
    required this.callId,
    this.reason,
  });
}

class DeclineCallUseCase {
  final CallsRepository _repository;

  DeclineCallUseCase(this._repository);

  Future<void> call(DeclineCallParams params) {
    return _repository.declineCall(params.callId, reason: params.reason);
  }
}
