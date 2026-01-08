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

    final data = response.data['data'] as Map<String, dynamic>;
    final userMap = data['user'] as Map<String, dynamic>;

    // Try to extract session_id from Set-Cookie header
    String accessToken = '';
    final cookies = response.headers['set-cookie'];
    print('DEBUG: Response Headers: ${response.headers}');
    print('DEBUG: Set-Cookie Header: $cookies');

    if (cookies != null && cookies.isNotEmpty) {
      for (final cookie in cookies) {
        if (cookie.contains('session_id=')) {
          // Extract value between session_id= and ;
          final parts = cookie.split(';');
          for (final part in parts) {
            if (part.trim().startsWith('session_id=')) {
              accessToken = part.trim().split('=')[1];
              print('DEBUG: Found cookie session_id: $accessToken');
              break;
            }
          }
        }
      }
    }

    // Fallback to body token if no cookie found
    if (accessToken.isEmpty) {
      print('DEBUG: No cookie found, falling back to body token');
      accessToken = data['accessToken'] ?? data['token'] ?? '';
    }

    print('DEBUG: Final Access Token: $accessToken');

    final refreshToken = data['refreshToken'] ?? data['refresh_token'];

    return AuthSessionDto(
      user: UserDto.fromJson(userMap),
      accessToken: accessToken, // Storing session_id here
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
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

    // Similar extraction for SignUp if it logs in automatically
    final data = response.data['data'] as Map<String, dynamic>;
    String accessToken = '';
    final cookies = response.headers['set-cookie'];
    print('DEBUG: SignUp Response Headers: ${response.headers}');
    print('DEBUG: SignUp Set-Cookie Header: $cookies');

    if (cookies != null && cookies.isNotEmpty) {
      for (final cookie in cookies) {
        if (cookie.contains('session_id=')) {
          final parts = cookie.split(';');
          for (final part in parts) {
            if (part.trim().startsWith('session_id=')) {
              accessToken = part.trim().split('=')[1];
              print('DEBUG: SignUp Found cookie session_id: $accessToken');
              break;
            }
          }
        }
      }
    }

    // Fallback if no cookie
    if (accessToken.isEmpty) {
      print('DEBUG: SignUp No cookie found, falling back to body token');
      // check body
      accessToken = data['accessToken'] ?? data['token'] ?? '';
    }

    print('DEBUG: SignUp Final Access Token: $accessToken');

    // We need to return AuthSessionDto, but standard fromJson might miss the cookie token
    // So we manually construct it if we found a cookie
    if (accessToken.isNotEmpty) {
      final userMap = data['user'] as Map<String, dynamic>;
      return AuthSessionDto(
        user: UserDto.fromJson(userMap),
        accessToken: accessToken,
        refreshToken: data['refreshToken'],
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
    }

    return AuthSessionDto.fromJson(data);
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      // Ignore 404 or other errors on logout, just clear local session
      print('DEBUG: SignOut API failed: $e');
    }
  }

  Future<AuthSessionDto> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return AuthSessionDto.fromJson(response.data as Map<String, dynamic>);
  }
}
