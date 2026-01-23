import '../../data/models/job_request_details_model.dart';

/// Repository interface for job request operations.
abstract class JobRequestRepository {
  /// Get job request details for a specific application.
  Future<JobRequestDetailsModel> getJobRequestDetails(String applicationId);

  /// Accept a job invitation or direct booking.
  Future<void> acceptJobInvitation(
    String applicationId, {
    required String applicationType,
  });

  /// Decline a job invitation or direct booking.
  Future<void> declineJobInvitation(
    String applicationId, {
    required String applicationType,
    required String reason,
    String? otherReason,
  });

  /// Clock in to a booking with device location.
  Future<void> clockInBooking(
    String applicationId, {
    required double latitude,
    required double longitude,
  });
}
