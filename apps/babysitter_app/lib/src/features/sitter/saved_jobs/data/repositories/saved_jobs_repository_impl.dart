import 'package:domain/domain.dart';
import '../../domain/repositories/saved_jobs_repository.dart';
import '../sources/saved_jobs_remote_datasource.dart';

class SavedJobsRepositoryImpl implements SavedJobsRepository {
  final SavedJobsRemoteDataSource _remote;

  SavedJobsRepositoryImpl(this._remote);

  @override
  Future<List<Job>> getSavedJobs() {
    return _remote.getSavedJobs();
  }

  @override
  Future<void> saveJob(String jobId) {
    return _remote.saveJob(jobId);
  }

  @override
  Future<void> removeJob(String jobId) {
    return _remote.removeJob(jobId);
  }
}
