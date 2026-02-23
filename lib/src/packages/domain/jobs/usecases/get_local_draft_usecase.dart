import 'package:babysitter_app/src/packages/domain/jobs/entities/job.dart';
import 'package:babysitter_app/src/packages/domain/jobs/repositories/job_repository.dart';

class GetLocalDraftUseCase {
  final JobRepository _repository;

  GetLocalDraftUseCase(this._repository);

  Future<Job?> call() async {
    return _repository.getLocalDraft();
  }
}
