import 'package:babysitter_app/src/features/calls/domain/entities/call_config.dart';
import 'package:babysitter_app/src/features/calls/domain/repositories/calls_repository.dart';

class GetCallConfigUseCase {
  final CallsRepository _repository;

  GetCallConfigUseCase(this._repository);

  Future<CallConfig> call() {
    return _repository.getCallConfig();
  }
}
