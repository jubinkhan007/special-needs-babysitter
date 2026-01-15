import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:auth/auth.dart';
import 'package:babysitter_app/src/features/parent/account/profile_details/presentation/providers/profile_details_providers.dart';
import '../controllers/job_post_controller.dart';

/// Authenticated Dio provider for Job API.
final jobPostDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://babysitter-backend.waywisetech.com/api',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add Auth Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final authState = ref.read(authNotifierProvider);
      var session = authState.valueOrNull;

      if (session == null) {
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          options.headers['Cookie'] = 'session_id=$storedToken';
        }
      } else {
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      print('DEBUG: Job API Error Status: ${e.response?.statusCode}');
      print('DEBUG: Job API Error Message: ${e.message}');
      print('DEBUG: Job API Error Data: ${e.response?.data}');
      return handler.next(e);
    },
  ));

  return dio;
});

/// Provider for the JobRemoteDataSource.
final jobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSource(ref.watch(jobPostDioProvider));
});

/// Provider for the JobLocalDataSource.
final jobLocalDataSourceProvider = Provider<JobLocalDataSource>((ref) {
  return JobLocalDataSource();
});

/// Provider for the JobRepository.
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final remoteDataSource = ref.watch(jobRemoteDataSourceProvider);
  final localDataSource = ref.watch(jobLocalDataSourceProvider);
  return JobRepositoryImpl(remoteDataSource, localDataSource);
});

/// Provider for the CreateJobUseCase.
final createJobUseCaseProvider = Provider<CreateJobUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return CreateJobUseCase(repository);
});

/// Provider for the UpdateJobUseCase.
final updateJobUseCaseProvider = Provider<UpdateJobUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return UpdateJobUseCase(repository);
});

/// Provider for the SaveLocalDraftUseCase.
final saveLocalDraftUseCaseProvider = Provider<SaveLocalDraftUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return SaveLocalDraftUseCase(repository);
});

/// Provider for the GetLocalDraftUseCase.
final getLocalDraftUseCaseProvider = Provider<GetLocalDraftUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return GetLocalDraftUseCase(repository);
});

/// Provider for the ClearLocalDraftUseCase.
final clearLocalDraftUseCaseProvider = Provider<ClearLocalDraftUseCase>((ref) {
  final repository = ref.watch(jobRepositoryProvider);
  return ClearLocalDraftUseCase(repository);
});

/// Provider for the JobPostController.
final jobPostControllerProvider =
    StateNotifierProvider<JobPostController, JobPostState>((ref) {
  final createJobUseCase = ref.watch(createJobUseCaseProvider);
  final updateJobUseCase = ref.watch(updateJobUseCaseProvider);
  final saveLocalDraftUseCase = ref.watch(saveLocalDraftUseCaseProvider);
  final getLocalDraftUseCase = ref.watch(getLocalDraftUseCaseProvider);
  final clearLocalDraftUseCase = ref.watch(clearLocalDraftUseCaseProvider);

  return JobPostController(
    createJobUseCase,
    updateJobUseCase,
    saveLocalDraftUseCase,
    getLocalDraftUseCase,
    clearLocalDraftUseCase,
  );
});

/// Provider for User Profile Details (containing children).
final profileDetailsProvider = FutureProvider<UserProfileDetails>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final session = authState.valueOrNull;
  if (session == null) throw Exception('User not authenticated');

  final useCase = ref.watch(getProfileDetailsUseCaseProvider);
  return useCase(session.user.id);
});
