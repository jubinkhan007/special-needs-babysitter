import '../../domain/applications/application_item.dart';
import '../../domain/applications/booking_application.dart';

/// Repository interface for job applications.
abstract class ApplicationsRepository {
  /// Fetches all applications for a specific job.
  Future<List<ApplicationItem>> getApplications(String jobId);

  /// Fetches a single application's detail by ID.
  Future<BookingApplication> getApplicationDetail({
    required String jobId,
    required String applicationId,
  });

  /// Accepts an application.
  Future<void> acceptApplication({
    required String jobId,
    required String applicationId,
  });

  /// Declines an application with a reason.
  Future<void> declineApplication({
    required String jobId,
    required String applicationId,
    required String reason,
  });
}
