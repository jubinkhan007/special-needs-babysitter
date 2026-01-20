enum AppExceptionType {
  network,
  server,
  unauthorized,
  validation,
  unknown,
  cancelled,
}

class AppException implements Exception {
  final String title;
  final String message;
  final AppExceptionType type;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.title,
    required this.message,
    required this.type,
    this.code,
    this.originalError,
  });

  @override
  String toString() =>
      'AppException(type: $type, title: $title, message: $message, code: $code)';
}
