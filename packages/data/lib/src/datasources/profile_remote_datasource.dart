import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

import '../dtos/user_dto.dart';

/// Remote data source for profile API calls
class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<UserDto> getMe() async {
    final response = await _dio.get('/users/me');
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserDto> updateProfile(UpdateProfileParams params) async {
    final response = await _dio.patch(
      '/users/me',
      data: {
        if (params.firstName != null) 'first_name': params.firstName,
        if (params.lastName != null) 'last_name': params.lastName,
        if (params.phoneNumber != null) 'phone_number': params.phoneNumber,
        if (params.avatarUrl != null) 'avatar_url': params.avatarUrl,
      },
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }
}
