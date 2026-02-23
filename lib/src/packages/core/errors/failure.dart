import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure for server-side errors
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
    super.originalError,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Failure for cache/storage operations
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalError,
  });
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

/// Failure for missing or invalid configuration
class ConfigFailure extends Failure {
  const ConfigFailure({
    required super.message,
    super.code = 'CONFIG_ERROR',
    super.originalError,
  });
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
    super.originalError,
  });
}
