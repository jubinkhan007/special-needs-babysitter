import 'package:dio/dio.dart';

import '../dtos/auth_session_dto.dart';

/// Remote data source for authentication API calls
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<AuthSessionDto> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/sign-in',
      data: {'email': email, 'password': password},
    );
    return AuthSessionDto.fromJson(response.data as Map<String, dynamic>);
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
