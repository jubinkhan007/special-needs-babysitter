import '../../data/models/job_request_details_model.dart';

/// Repository interface for job request operations.
abstract class JobRequestRepository {
  /// Get job request details for a specific application.
  Future<JobRequestDetailsModel> getJobRequestDetails(String applicationId);

  /// Accept a job invitation.
  Future<void> acceptJobInvitation(String applicationId);

  /// Decline a job invitation.
  Future<void> declineJobInvitation(String applicationId);
}
