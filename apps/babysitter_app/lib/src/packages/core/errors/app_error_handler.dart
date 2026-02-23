import 'package:dio/dio.dart';
import 'app_exception.dart';

class AppErrorHandler {
  static AppException parse(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    return const AppException(
      type: AppExceptionType.unknown,
      title: 'Something went wrong',
      message: 'An unexpected error occurred. Please try again.',
    );
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          type: AppExceptionType.network,
          title: 'Connection Timeout',
          message: 'The connection timed out. Please check your internet.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const AppException(
            type: AppExceptionType.unauthorized,
            title: 'Session Expired',
            message: 'Your session has expired. Please log in again.',
          );
        } else if (statusCode == 403) {
          return const AppException(
            type: AppExceptionType.unauthorized,
            title: 'Access Denied',
            message: 'You do not have permission to access this resource.',
          );
        } else if (statusCode == 404) {
          return const AppException(
            type: AppExceptionType.server,
            title: 'Not Found',
            message: 'The requested resource was not found.',
          );
        } else if (statusCode != null && statusCode >= 500) {
          return const AppException(
            type: AppExceptionType.server,
            title: 'Server Error',
            message:
                'We are experiencing server issues. Please try again later.',
          );
        }
        return AppException(
          type: AppExceptionType.server,
          title: 'Error',
          message: error.response?.statusMessage ?? 'An error occurred.',
          code: statusCode?.toString(),
        );
      case DioExceptionType.cancel:
        return const AppException(
          type: AppExceptionType.cancelled,
          title: 'Cancelled',
          message: 'Request was cancelled.',
        );
      case DioExceptionType.connectionError:
        return const AppException(
          type: AppExceptionType.network,
          title: 'No Internet',
          message:
              'Unable to connect to the server. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        return const AppException(
          type: AppExceptionType.unknown,
          title: 'Something went wrong',
          message: 'An unexpected error occurred. Please try again.',
        );
      default:
        return const AppException(
          type: AppExceptionType.unknown,
          title: 'Something went wrong',
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }
}
