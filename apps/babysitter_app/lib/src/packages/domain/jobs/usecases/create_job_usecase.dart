import '../entities/job.dart';
import '../repositories/job_repository.dart';
import '../../usecases/usecase.dart';

/// Use case for creating a new job posting.
class CreateJobUseCase implements UseCase<String, Job> {
  final JobRepository _repository;

  CreateJobUseCase(this._repository);

  @override
  Future<String> call(Job job) {
    return _repository.createJob(job);
  }
}
