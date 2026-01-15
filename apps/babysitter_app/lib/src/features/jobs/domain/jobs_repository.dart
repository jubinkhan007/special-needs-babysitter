import 'job.dart';
import 'job_details.dart';

abstract class JobsRepository {
  Future<List<Job>> getJobs();
  Future<JobDetails> getJobDetails(String id);
  Future<void> updateJob(String id, Map<String, dynamic> data);
  Future<void> deleteJob(String id);
}
