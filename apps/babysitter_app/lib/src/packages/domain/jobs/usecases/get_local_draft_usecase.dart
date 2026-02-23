import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetLocalDraftUseCase {
  final JobRepository _repository;

  GetLocalDraftUseCase(this._repository);

  Future<Job?> call() async {
    return _repository.getLocalDraft();
  }
}
