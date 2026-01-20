/// Repository interface for job applications.
abstract class ApplicationRepository {
  /// Submit a job application.
  Future<void> submitApplication({
    required String jobId,
    required String coverLetter,
  });
}
