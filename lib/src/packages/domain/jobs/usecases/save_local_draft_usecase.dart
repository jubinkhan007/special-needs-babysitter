import 'package:babysitter_app/src/packages/domain/jobs/entities/job.dart';
import 'package:babysitter_app/src/packages/domain/jobs/repositories/job_repository.dart';

class SaveLocalDraftUseCase {
  final JobRepository _repository;

  SaveLocalDraftUseCase(this._repository);

  Future<void> call(Job job) async {
    return _repository.saveLocalDraft(job);
  }
}
