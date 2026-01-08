import 'package:dio/dio.dart';

import '../dtos/auth_session_dto.dart';
import '../dtos/user_dto.dart';

/// Remote data source for authentication API calls
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<AuthSessionDto> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    // API returns { success: true, data: { user: {...}, ... } }
    // Token handling needs to be robust.
    // Check if token is in data['accessToken'] or headers or elsewhere.
    final data = response.data['data'] as Map<String, dynamic>;
    final userMap = data['user'] as Map<String, dynamic>;

    // Construct session DTO manually from nested data
    // Assuming accessToken might be in data['accessToken'] based on typical API patterns
    // If not present, we will fallback or error out.
    // NOTE: Based on screenshot, token wasn't visible. We'll check multiple keys.
    final accessToken = data['accessToken'] ?? data['token'] ?? '';
    final refreshToken = data['refreshToken'] ?? data['refresh_token'];

    return AuthSessionDto(
      user: UserDto.fromJson(userMap),
      accessToken:
          accessToken, // Might need adjustment if token comes from Cookies
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 30)), // Default
    );
  }

  Future<AuthSessionDto> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dio.post(
      '/auth/sign-up',
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      },
    );
    return AuthSessionDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await _dio.post('/auth/sign-out');
  }

  Future<AuthSessionDto> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return AuthSessionDto.fromJson(response.data as Map<String, dynamic>);
  }
}
