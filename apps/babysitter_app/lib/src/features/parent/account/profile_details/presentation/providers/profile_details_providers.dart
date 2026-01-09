import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:auth/auth.dart';

import '../controllers/profile_details_controller.dart';
import '../state/profile_details_state.dart';

import 'package:dio/dio.dart';

// Authenticated Dio Provider
final profileDetailsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://sns-apis.tausifk.com/api',
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
      // Log error details for debugging
      print(
          'DEBUG: ProfileDetails API Error: ${e.message} ${e.response?.statusCode}');
      return handler.next(e);
    },
  ));

  return dio;
});

// Data Source
final profileDetailsRemoteDataSourceProvider =
    Provider<ProfileDetailsRemoteDataSource>((ref) {
  return ProfileDetailsRemoteDataSource(ref.watch(profileDetailsDioProvider));
});

// Repository
final profileDetailsRepositoryProvider =
    Provider<ProfileDetailsRepository>((ref) {
  final remoteDataSource = ref.watch(profileDetailsRemoteDataSourceProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);

  // Create AccountRemoteDataSource just for the repo (or reuse if we want)
  // Re-using the logic from AccountRepoImpl requirement
  final accountRemoteDataSource =
      AccountRemoteDataSource(ref.watch(authDioProvider));
  final accountRepository =
      AccountRepositoryImpl(accountRemoteDataSource, profileRepository);

  return ProfileDetailsRepositoryImpl(remoteDataSource, accountRepository);
});

// Use Case
final getProfileDetailsUseCaseProvider =
    Provider<GetProfileDetailsUseCase>((ref) {
  return GetProfileDetailsUseCase(ref.read(profileDetailsRepositoryProvider));
});

// Controller
final profileDetailsControllerProvider =
    AsyncNotifierProvider<ProfileDetailsController, ProfileDetailsState>(
        () => ProfileDetailsController());
