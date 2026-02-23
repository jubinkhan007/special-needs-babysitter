import 'package:babysitter_app/src/features/calls/domain/repositories/calls_repository.dart';

class EndCallUseCase {
  final CallsRepository _repository;

  EndCallUseCase(this._repository);

  Future<void> call(String callId) {
    return _repository.endCall(callId);
  }
}
