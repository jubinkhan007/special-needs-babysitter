import '../repositories/job_repository.dart';

class ClearLocalDraftUseCase {
  final JobRepository _repository;

  ClearLocalDraftUseCase(this._repository);

  Future<void> call() async {
    return _repository.clearLocalDraft();
  }
}
