import '../../data/models/application_model.dart';

/// Repository interface for job applications.
abstract class ApplicationRepository {
  /// Submit a job application.
  Future<void> submitApplication({
    required String jobId,
    required String coverLetter,
  });

  /// Get applications list.
  Future<List<ApplicationModel>> getApplications({
    String? status,
    String? type,
    int limit = 20,
    int offset = 0,
  });

  /// Get a single application by ID.
  Future<ApplicationModel> getApplicationById(String applicationId);
}
