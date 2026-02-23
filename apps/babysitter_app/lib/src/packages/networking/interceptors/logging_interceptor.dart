import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Interceptor that logs HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('→ ${options.method} ${options.uri}', name: 'HTTP');
    if (options.data != null) {
      developer.log('Body: ${options.data}', name: 'HTTP');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✗ ${err.response?.statusCode ?? 'NETWORK'} ${err.requestOptions.uri}',
      name: 'HTTP',
      error: err.message,
    );
    handler.next(err);
  }
}
