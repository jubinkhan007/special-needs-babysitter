import 'package:dio/dio.dart';

/// Interceptor that adds authentication token to requests
class AuthInterceptor extends Interceptor {
  final String? Function() tokenGetter;
  final void Function()? onUnauthorized;

  AuthInterceptor({required this.tokenGetter, this.onUnauthorized});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenGetter();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
