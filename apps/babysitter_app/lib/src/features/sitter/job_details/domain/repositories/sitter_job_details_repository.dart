import '../entities/sitter_job_details.dart';

/// Repository interface for sitter job details.
abstract class SitterJobDetailsRepository {
  /// Get job details by ID.
  Future<SitterJobDetails> getJobDetails(String jobId);
}
