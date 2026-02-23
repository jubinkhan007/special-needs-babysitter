import '../entities/job.dart';
import '../repositories/job_repository.dart';
import '../../usecases/usecase.dart';

/// Use case for updating an existing job posting.
class UpdateJobUseCase implements UseCase<void, Job> {
  final JobRepository _repository;

  UpdateJobUseCase(this._repository);

  @override
  Future<void> call(Job job) {
    return _repository.updateJob(job);
  }
}
