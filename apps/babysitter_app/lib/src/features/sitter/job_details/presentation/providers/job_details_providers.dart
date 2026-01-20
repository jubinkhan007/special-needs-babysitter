import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../domain/entities/sitter_job_details.dart';
import '../../domain/repositories/sitter_job_details_repository.dart';
import '../../data/repositories/sitter_job_details_repository_impl.dart';
import '../../data/sources/sitter_job_details_remote_source.dart';

/// Provider for the job details remote source.
final sitterJobDetailsRemoteSourceProvider =
    Provider<SitterJobDetailsRemoteSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return SitterJobDetailsRemoteSource(dio);
});

/// Provider for the job details repository.
final sitterJobDetailsRepositoryProvider =
    Provider<SitterJobDetailsRepository>((ref) {
  final remoteSource = ref.watch(sitterJobDetailsRemoteSourceProvider);
  return SitterJobDetailsRepositoryImpl(remoteSource);
});

/// Provider for fetching job details by ID.
final sitterJobDetailsProvider =
    FutureProvider.family<SitterJobDetails, String>((ref, jobId) async {
  final repository = ref.watch(sitterJobDetailsRepositoryProvider);
  return repository.getJobDetails(jobId);
});
