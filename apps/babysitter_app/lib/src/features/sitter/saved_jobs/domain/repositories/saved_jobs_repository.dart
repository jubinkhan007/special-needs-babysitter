import 'package:domain/domain.dart';

abstract class SavedJobsRepository {
  Future<List<Job>> getSavedJobs();
  Future<void> saveJob(String jobId);
  Future<void> removeJob(String jobId);
}
