import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../domain/entities/job_application_preview.dart';
import '../../domain/repositories/application_repository.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../data/sources/application_remote_datasource.dart';
import '../../../job_details/presentation/providers/job_details_providers.dart';

/// Provider for the application remote data source.
final applicationRemoteDataSourceProvider =
    Provider<ApplicationRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return ApplicationRemoteDataSource(dio);
});

/// Provider for the application repository.
final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  final remoteSource = ref.watch(applicationRemoteDataSourceProvider);
  return ApplicationRepositoryImpl(remoteSource);
});

typedef ApplicationPreviewArgs = ({String jobId, String coverLetter});

/// Provider for fetching application preview data with explicit cover letter.
final applicationPreviewProviderWithData =
    FutureProvider.family<JobApplicationPreview, ApplicationPreviewArgs>(
        (ref, args) async {
  print(
      'DEBUG: applicationPreviewProviderWithData called for jobId=${args.jobId}');

  final jobDetails =
      await ref.watch(sitterJobDetailsProvider(args.jobId).future);

  return JobApplicationPreview(
    jobId: args.jobId,
    jobDetails: jobDetails,
    coverLetter: args.coverLetter,
  );
});

/// Legacy provider (kept for backward compatibility if needed, but updated to use 'withData')
final applicationPreviewProvider =
    FutureProvider.family<JobApplicationPreview, String>((ref, jobId) async {
  return ref.watch(applicationPreviewProviderWithData((
    jobId: jobId,
    coverLetter:
        "I'm a responsible and caring sitter with a passion for working with children. I have experience with various age groups and am comfortable with special needs. I'm also CPR certified and have a clean background check.",
  )).future);
});

/// State for application submission.
class SubmitApplicationState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const SubmitApplicationState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  SubmitApplicationState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return SubmitApplicationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier for handling application submission.
class SubmitApplicationNotifier extends StateNotifier<SubmitApplicationState> {
  final ApplicationRepository _repository;

  SubmitApplicationNotifier(this._repository)
      : super(const SubmitApplicationState());

  /// Submit the application.
  Future<bool> submit({
    required String jobId,
    required String coverLetter,
  }) async {
    print('DEBUG: SubmitApplicationNotifier.submit called');
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      await _repository.submitApplication(
        jobId: jobId,
        coverLetter: coverLetter,
      );

      print('DEBUG: Submit successful');
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      print('DEBUG: Submit failed: $e');
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isSuccess: false,
      );
      return false;
    }
  }

  /// Reset state.
  void reset() {
    state = const SubmitApplicationState();
  }
}

/// Provider for the submit application notifier.
final submitApplicationControllerProvider =
    StateNotifierProvider<SubmitApplicationNotifier, SubmitApplicationState>(
        (ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return SubmitApplicationNotifier(repository);
});
