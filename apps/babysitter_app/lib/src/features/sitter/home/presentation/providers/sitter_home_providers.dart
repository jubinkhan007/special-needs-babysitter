import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import 'package:babysitter_app/src/constants/app_constants.dart';

/// User authentificated Dio for Sitter Home
final sitterHomeDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
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
      print('DEBUG: Sitter Home API Error: ${e.message}');
      return handler.next(e);
    },
  ));

  return dio;
});

final sitterJobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSource(ref.watch(sitterHomeDioProvider));
});

final sitterJobLocalDataSourceProvider = Provider<JobLocalDataSource>((ref) {
  return JobLocalDataSource();
});

final sitterJobRepositoryProvider = Provider<JobRepository>((ref) {
  final remote = ref.watch(sitterJobRemoteDataSourceProvider);
  final local = ref.watch(sitterJobLocalDataSourceProvider);
  return JobRepositoryImpl(remote, local);
});

class JobsNotifier extends AsyncNotifier<List<Job>> {
  @override
  Future<List<Job>> build() async {
    print('DEBUG: JobsNotifier build started');
    try {
      final repository = ref.watch(sitterJobRepositoryProvider);
      print('DEBUG: JobsNotifier calling getPublicJobs');
      final jobs = await repository.getPublicJobs();
      print('DEBUG: JobsNotifier received ${jobs.length} jobs');
      return jobs;
    } catch (e, st) {
      print('DEBUG: JobsNotifier error: $e');
      print('DEBUG: JobsNotifier stack: $st');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sitterJobRepositoryProvider);
      return repository.getPublicJobs();
    });
  }
}

final jobsNotifierProvider =
    AsyncNotifierProvider<JobsNotifier, List<Job>>(JobsNotifier.new);
