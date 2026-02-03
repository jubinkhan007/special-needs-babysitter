import '../entities/call_config.dart';
import '../repositories/calls_repository.dart';

class GetCallConfigUseCase {
  final CallsRepository _repository;

  GetCallConfigUseCase(this._repository);

  Future<CallConfig> call() {
    return _repository.getCallConfig();
  }
}
