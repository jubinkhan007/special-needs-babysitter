import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import '../../dtos/auth_session_dto.dart';
import '../../dtos/user_dto.dart';

/// Remote data source for registration API calls
class RegistrationRemoteDataSource {
  final Dio _dio;

  RegistrationRemoteDataSource(this._dio);

  /// POST /auth/register
  /// API returns: {"success": true, "userId": "...", "message": "..."}
  Future<RegisteredUser> register(RegistrationPayload payload) async {
    final response = await _dio.post(
      '/auth/register',
      data: payload.toJson(),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException('Invalid response format: $data');
    }

    // API returns nested data: { success: true, data: { user: { id: "..." } } }
    String? userId;

    // Try getting from root (old assumption)
    if (data['userId'] is String) {
      userId = data['userId'];
    }
    // Try getting from nested data.user.id (actual API)
    else if (data['data'] is Map<String, dynamic>) {
      final innerData = data['data'] as Map<String, dynamic>;
      if (innerData['user'] is Map<String, dynamic>) {
        userId = innerData['user']['id'];
      } else if (innerData['id'] is String) {
        userId = innerData['id'];
      }
    }
    // Try getting from root id (fallback)
    else if (data['id'] is String) {
      userId = data['id'];
    }

    if (userId == null) {
      print('Registration successful but userId missing/invalid. Data: $data');
      throw FormatException('Missing userId in response: $data');
    }

    return _createUser(payload, userId);
  }

  RegisteredUser _createUser(RegistrationPayload payload, String userId) {
    return RegisteredUser(
      id: userId,
      email: payload.email,
      firstName: payload.firstName,
      lastName: payload.lastName,
      middleInitial: payload.middleInitial,
      phone: payload.phone,
      role: payload.role,
      phoneVerified: false,
      emailVerified: false,
      createdAt: DateTime.now(),
    );
  }

  /// POST /auth/otp/send
  Future<void> sendOtp(OtpSendPayload payload) async {
    await _dio.post(
      '/auth/otp/send',
      data: payload.toJson(),
    );
  }

  /// POST /auth/otp/verify
  Future<AuthSessionDto> verifyOtp(OtpVerifyPayload payload) async {
    final response = await _dio.post(
      '/auth/otp/verify',
      data: payload.toJson(),
    );

    final data = response.data['data'] as Map<String, dynamic>;

    // Cookie Extraction Logic
    String accessToken = '';
    final cookies = response.headers['set-cookie'];
    print('DEBUG: VerifyOTP Response Headers: ${response.headers}');
    print('DEBUG: VerifyOTP Set-Cookie Header: $cookies');

    if (cookies != null && cookies.isNotEmpty) {
      for (final cookie in cookies) {
        if (cookie.contains('session_id=')) {
          final parts = cookie.split(';');
          for (final part in parts) {
            if (part.trim().startsWith('session_id=')) {
              accessToken = part.trim().split('=')[1];
              print('DEBUG: VerifyOTP Found cookie session_id: $accessToken');
              break;
            }
          }
        }
      }
    }

    // Fallback if no cookie
    if (accessToken.isEmpty) {
      print('DEBUG: VerifyOTP No cookie found, falling back to body token');
      accessToken = data['accessToken'] ?? data['token'] ?? '';
    }

    if (accessToken.isNotEmpty) {
      final userMap = data['user'] as Map<String, dynamic>;
      // Handle the case where the user object might be nested differently
      final userDto = UserDto.fromJson(userMap);

      return AuthSessionDto(
        user: userDto,
        accessToken: accessToken,
        refreshToken: data['refreshToken'],
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
    }

    return AuthSessionDto.fromJson(data);
  }

  /// POST /auth/check-uniqueness
  /// API returns: { success: true, data: { message: "...", available: true } }
  Future<UniquenessCheckResult> checkUniqueness(
    UniquenessCheckPayload payload,
  ) async {
    final response = await _dio.post(
      '/auth/check-uniqueness',
      data: payload.toJson(),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException('Invalid response format: $data');
    }

    final success = data['success'] == true;
    final inner = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : null;
    final available = inner?['available'] == true;
    final message =
        (inner?['message'] ?? data['message'] ?? data['error'])?.toString();

    return UniquenessCheckResult(
      success: success,
      available: available,
      message: (message != null && message.isNotEmpty)
          ? message
          : (available
              ? 'Email and phone number are available'
              : 'Email or phone number already exists'),
    );
  }

  /// GET /auth/security-questions
  Future<List<String>> getSecurityQuestions() async {
    final response = await _dio.get('/auth/security-questions');
    final data = response.data as Map<String, dynamic>;
    final questions = data['questions'] as List<dynamic>;
    return questions.cast<String>();
  }
}
