import 'package:dio/dio.dart';
import 'package:core/core.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Factory for creating configured Dio instances
class DioClient {
  DioClient._();

  /// Creates a new Dio instance with default configuration
  static Dio create({
    String? baseUrl,
    String? Function()? tokenGetter,
    void Function()? onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? EnvConfig.apiBaseUrl,
        connectTimeout: Constants.connectionTimeout,
        receiveTimeout: Constants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order
    dio.interceptors.addAll([
      LoggingInterceptor(),
      if (tokenGetter != null)
        AuthInterceptor(
          tokenGetter: tokenGetter,
          onUnauthorized: onUnauthorized,
        ),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
