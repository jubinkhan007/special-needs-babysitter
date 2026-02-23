import 'package:babysitter_app/src/packages/domain/jobs/entities/job.dart';
import 'package:babysitter_app/src/packages/domain/jobs/repositories/job_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

/// Use case for updating an existing job posting.
class UpdateJobUseCase implements UseCase<void, Job> {
  final JobRepository _repository;

  UpdateJobUseCase(this._repository);

  @override
  Future<void> call(Job job) {
    return _repository.updateJob(job);
  }
}
