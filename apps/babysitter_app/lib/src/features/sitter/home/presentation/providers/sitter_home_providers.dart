import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import 'package:babysitter_app/src/constants/app_constants.dart';

import '../../data/dtos/sitter_job_preview_dto.dart';
import '../../domain/entities/job_preview.dart';

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

/// Notifier for job previews - fetches from API and parses with correct DTO
class JobPreviewsNotifier extends AsyncNotifier<List<JobPreview>> {
  @override
  Future<List<JobPreview>> build() async {
    final dio = ref.watch(sitterHomeDioProvider);

    final response = await dio.get(
      '/jobs',
      queryParameters: {'status': 'posted', 'limit': 20, 'offset': 0},
    );

    if (response.data['success'] == true) {
      final List<dynamic> jobsJson = response.data['data']['jobs'];

      final previews = <JobPreview>[];
      for (final json in jobsJson) {
        try {
          final dto =
              SitterJobPreviewDto.fromJson(json as Map<String, dynamic>);
          previews.add(dto.toDomain());
        } catch (e) {
          // Skip jobs that fail to parse
          print('Warning: Failed to parse job preview: $e');
        }
      }

      return previews;
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Provider for job previews - use this in the UI
final jobPreviewsNotifierProvider =
    AsyncNotifierProvider<JobPreviewsNotifier, List<JobPreview>>(
        JobPreviewsNotifier.new);

// Keep the old provider for backwards compatibility with other screens
class JobsNotifier extends AsyncNotifier<List<Job>> {
  @override
  Future<List<Job>> build() async {
    final repository = ref.watch(sitterJobRepositoryProvider);
    return repository.getPublicJobs();
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
