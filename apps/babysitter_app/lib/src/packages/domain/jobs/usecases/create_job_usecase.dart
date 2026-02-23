import 'package:babysitter_app/src/packages/domain/jobs/entities/job.dart';
import 'package:babysitter_app/src/packages/domain/jobs/repositories/job_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

/// Use case for creating a new job posting.
class CreateJobUseCase implements UseCase<String, Job> {
  final JobRepository _repository;

  CreateJobUseCase(this._repository);

  @override
  Future<String> call(Job job) {
    return _repository.createJob(job);
  }
}
