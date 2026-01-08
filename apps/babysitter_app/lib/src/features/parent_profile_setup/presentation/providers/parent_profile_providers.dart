import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import '../controllers/parent_profile_controller.dart';

/// Temporarily creating a local Dio provider if a global one isn't easily accessible
/// In a real app, import this from core/network/dio_provider.dart
final parentProfileDioProvider = Provider<Dio>((ref) {
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

      print('DEBUG: Interceptor - Session is null? ${session == null}');

      // Fallback: Check SessionStore if AuthNotifier is null
      if (session == null) {
        print(
            'DEBUG: Interceptor - Session is null, checking storage fallback...');
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          print(
              'DEBUG: Interceptor - Found valid token in storage: $storedToken');
          options.headers['Cookie'] = 'session_id=$storedToken';
        } else {
          print('DEBUG: Interceptor - No token in storage either.');
        }
      } else {
        print('DEBUG: Interceptor - AccessToken: ${session.accessToken}');
        // User reports server sets session_id=...
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
        print(
            'DEBUG: Interceptor - Setting Cookie Header: ${options.headers['Cookie']}');
      }

      print('DEBUG: Interceptor - Request: ${options.method} ${options.uri}');
      print('DEBUG: Interceptor - Request Data: ${options.data}');
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
