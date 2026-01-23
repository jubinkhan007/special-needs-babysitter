import 'dart:io';

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

  @override
  Future<void> clockInBooking(
    String applicationId, {
    required double latitude,
    required double longitude,
  }) {
    return _remoteDataSource.clockInBooking(
      applicationId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<String> uploadCancellationEvidence(File file) {
    return _remoteDataSource.uploadCancellationEvidence(file);
  }

  @override
  Future<void> cancelBooking(
    String applicationId, {
    required String reason,
    String? fileUrl,
  }) {
    return _remoteDataSource.cancelBooking(
      applicationId,
      reason: reason,
      fileUrl: fileUrl,
    );
  }

  @override
  Future<void> completeBooking(String applicationId) {
    return _remoteDataSource.completeBooking(applicationId);
  }
}
