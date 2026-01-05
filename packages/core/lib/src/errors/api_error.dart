/// Represents API error response structure
class ApiError {
  final int statusCode;
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.statusCode,
    required this.message,
    this.errorCode,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json, int statusCode) {
    return ApiError(
      statusCode: statusCode,
      message: json['message'] as String? ?? 'Unknown error',
      errorCode: json['code'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => statusCode >= 500;
}
