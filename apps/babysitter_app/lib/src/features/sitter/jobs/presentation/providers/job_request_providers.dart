import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../domain/repositories/job_request_repository.dart';
import '../../data/repositories/job_request_repository_impl.dart';
import '../../data/sources/job_request_remote_datasource.dart';
import '../../data/models/job_request_details_model.dart';
import '../controllers/job_request_controller.dart';

/// Provider for the job request remote data source.
final jobRequestRemoteDataSourceProvider =
    Provider<JobRequestRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return JobRequestRemoteDataSource(dio);
});

/// Provider for the job request repository.
final jobRequestRepositoryProvider = Provider<JobRequestRepository>((ref) {
  final remoteSource = ref.watch(jobRequestRemoteDataSourceProvider);
  return JobRequestRepositoryImpl(remoteSource);
});

/// Provider for fetching job request details.
/// Pass the applicationId to fetch specific job request details.
final jobRequestDetailsProvider =
    FutureProvider.autoDispose.family<JobRequestDetailsModel, String>(
        (ref, applicationId) async {
  final repository = ref.watch(jobRequestRepositoryProvider);
  return repository.getJobRequestDetails(applicationId);
});

/// Provider for the job request controller (accept/decline actions).
final jobRequestControllerProvider =
    StateNotifierProvider<JobRequestController, AsyncValue<void>>((ref) {
  final repository = ref.watch(jobRequestRepositoryProvider);
  return JobRequestController(repository);
});
