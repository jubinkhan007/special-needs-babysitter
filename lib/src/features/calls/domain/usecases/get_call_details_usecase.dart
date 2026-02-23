import 'package:babysitter_app/src/features/calls/domain/entities/call_session.dart';
import 'package:babysitter_app/src/features/calls/domain/repositories/calls_repository.dart';

class GetCallDetailsUseCase {
  final CallsRepository _repository;

  GetCallDetailsUseCase(this._repository);

  Future<CallSession> call(String callId) {
    return _repository.getCallDetails(callId);
  }
}
