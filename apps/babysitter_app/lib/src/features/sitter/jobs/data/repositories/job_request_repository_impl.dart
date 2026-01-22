import '../../domain/repositories/job_request_repository.dart';
import '../models/job_request_details_model.dart';
import '../sources/job_request_remote_datasource.dart';

class JobRequestRepositoryImpl implements JobRequestRepository {
  final JobRequestRemoteDataSource _remoteDataSource;

  JobRequestRepositoryImpl(this._remoteDataSource);

  @override
  Future<JobRequestDetailsModel> getJobRequestDetails(String applicationId) {
    return _remoteDataSource.getJobRequestDetails(applicationId);
  }

  @override
  Future<void> acceptJobInvitation(
    String applicationId, {
    required String applicationType,
  }) {
    return _remoteDataSource.acceptJobInvitation(
      applicationId,
      applicationType: applicationType,
    );
  }

  @override
  Future<void> declineJobInvitation(
    String applicationId, {
    required String applicationType,
    required String reason,
    String? otherReason,
  }) {
    return _remoteDataSource.declineJobInvitation(
      applicationId,
      applicationType: applicationType,
      reason: reason,
      otherReason: otherReason,
    );
  }
}
