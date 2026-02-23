import '../entities/job.dart';

/// Repository interface for job related operations.
abstract class JobRepository {
  /// Posts a new job.
  Future<String> createJob(Job job);

  /// Fetches all jobs posted by the current user.
  Future<List<Job>> getJobs();

  /// Fetches public jobs (e.g. for sitters).
  Future<List<Job>> getPublicJobs(
      {int limit = 20, int offset = 0, String? status = 'posted',});

  /// Fetches a specific job by its ID.
  Future<Job> getJobById(String id);

  /// Updates an existing job.
  Future<void> updateJob(Job job);

  /// Cancels or deletes a job.
  Future<void> deleteJob(String id);

  /// Saves a job draft locally.
  Future<void> saveLocalDraft(Job job);

  /// Fetches the locally saved job draft.
  Future<Job?> getLocalDraft();

  /// Clears the locally saved job draft.
  Future<void> clearLocalDraft();

  /// Invites a sitter to a job.
  Future<void> inviteSitter(String jobId, String sitterId);
}
