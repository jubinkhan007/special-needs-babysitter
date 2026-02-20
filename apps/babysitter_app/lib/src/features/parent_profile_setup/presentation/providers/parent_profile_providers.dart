import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import '../../../../constants/app_constants.dart';
import '../controllers/parent_profile_controller.dart';
import 'package:flutter/foundation.dart';

/// Dio provider with auth interceptor for parent profile API calls.
/// In a real app, import this from core/network/dio_provider.dart
final parentProfileDioProvider = Provider<Dio>((ref) {
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
      var session = authState.value;

      debugPrint('DEBUG: Interceptor - Session is null? ${session == null}');

      // Fallback: Check SessionStore if AuthNotifier is null
      if (session == null) {
        debugPrint(
            'DEBUG: Interceptor - Session is null, checking storage fallback...');
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          debugPrint(
              'DEBUG: Interceptor - Found valid token in storage: $storedToken');
          options.headers['Cookie'] = 'session_id=$storedToken';
        } else {
          debugPrint('DEBUG: Interceptor - No token in storage either.');
        }
      } else {
        debugPrint('DEBUG: Interceptor - AccessToken: ${session.accessToken}');
        // User reports server sets session_id=...
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
        debugPrint(
            'DEBUG: Interceptor - Setting Cookie Header: ${options.headers['Cookie']}');
      }

      debugPrint('DEBUG: Interceptor - Request: ${options.method} ${options.uri}');
      debugPrint('DEBUG: Interceptor - Request Data: ${options.data}');
      return handler.next(options);
    },
  ));

  return dio;
});

final parentProfileRemoteDataSourceProvider =
    Provider<ParentProfileRemoteDataSource>((ref) {
  final dio = ref.watch(parentProfileDioProvider);
  return ParentProfileRemoteDataSource(dio);
});

final parentProfileRepositoryProvider =
    Provider<ParentProfileRepository>((ref) {
  final dataSource = ref.watch(parentProfileRemoteDataSourceProvider);
  return ParentProfileRepositoryImpl(dataSource);
});

final parentProfileControllerProvider =
    StateNotifierProvider<ParentProfileController, AsyncValue<void>>((ref) {
  final repository = ref.watch(parentProfileRepositoryProvider);
  return ParentProfileController(repository);
});
