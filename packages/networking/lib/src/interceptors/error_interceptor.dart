import 'package:dio/dio.dart';
import 'package:core/core.dart';

/// Interceptor that transforms Dio errors into application failures
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioErrorToFailure(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
      ),
    );
  }

  Failure _mapDioErrorToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Connection timed out',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);

      case DioExceptionType.cancel:
        return const UnexpectedFailure(
          message: 'Request cancelled',
          code: 'CANCELLED',
        );

      default:
        return UnexpectedFailure(
          message: err.message ?? 'Unknown error',
          originalError: err,
        );
    }
  }

  Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const UnexpectedFailure(message: 'No response received');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'Server error';
    String? code;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      code = data['code'] as String?;
    }

    if (statusCode == 401) {
      return AuthFailure(message: message, code: code);
    }

    if (statusCode == 422) {
      Map<String, List<String>>? fieldErrors;
      if (data is Map<String, dynamic> && data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        fieldErrors = errors.map(
          (key, value) =>
              MapEntry(key, (value as List).map((e) => e.toString()).toList()),
        );
      }
      return ValidationFailure(
        message: message,
        code: code,
        fieldErrors: fieldErrors,
      );
    }

    return ServerFailure(message: message, code: code, statusCode: statusCode);
  }
}
