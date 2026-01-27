import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

import '../dtos/user_dto.dart';

/// Remote data source for profile API calls
class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<UserDto> getMe() async {
    final response = await _dio.get('/users/me');
    print('DEBUG: ProfileRemoteDataSource getMe raw: ${response.data}');

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      print('ERROR: ProfileRemoteDataSource response is not a Map: $data');
      throw FormatException('Invalid response format: $data');
    }

    Map<String, dynamic>? userMap;

    // 1. Try nested data.user (as seen in logs)
    if (data['data'] is Map<String, dynamic>) {
      final innerData = data['data'] as Map<String, dynamic>;
      if (innerData['user'] is Map<String, dynamic>) {
        print('DEBUG: ProfileRemoteDataSource using data.user');
        userMap = innerData['user'] as Map<String, dynamic>;
      } else if (innerData.containsKey('id') &&
          innerData.containsKey('email')) {
        print('DEBUG: ProfileRemoteDataSource using data');
        userMap = innerData;
      }
    }

    // 2. Try root keys (legacy or different endpoint)
    if (userMap == null) {
      if (data['user'] is Map<String, dynamic>) {
        print('DEBUG: ProfileRemoteDataSource using root.user');
        userMap = data['user'] as Map<String, dynamic>;
      } else if (data.containsKey('id') && data.containsKey('email')) {
        print('DEBUG: ProfileRemoteDataSource using root');
        userMap = data;
      }
    }

    if (userMap == null) {
      print(
          'ERROR: ProfileRemoteDataSource failed to find user object. Keys: ${data.keys}');
      // Final attempt with the root just to keep old behavior but likely to fail if keys missing
      userMap = data;
    }

    // Fix for missing avatar_url: try to find it in 'profile' object
    if (userMap['avatar_url'] == null) {
      Map<String, dynamic>? profileMap;
      // Check data.data.profile
      if (data['data'] is Map<String, dynamic>) {
        final innerData = data['data'] as Map<String, dynamic>;
        if (innerData['profile'] is Map<String, dynamic>) {
          profileMap = innerData['profile'] as Map<String, dynamic>;
        }
      }
      // Check data.profile
      if (profileMap == null && data['profile'] is Map<String, dynamic>) {
        profileMap = data['profile'] as Map<String, dynamic>;
      }

      if (profileMap != null) {
        final photoUrl = profileMap['photoUrl'] ?? profileMap['photo_url'];
        if (photoUrl != null) {
          print('DEBUG: Found photoUrl in profile object, mapping to avatar_url');
          userMap['avatar_url'] = photoUrl;
        }
      }
    }

    // Extra safety: ensure id and email are present before calling fromJson if possible
    print('DEBUG: ProfileRemoteDataSource final userMap keys: ${userMap.keys}');
    print(
        'DEBUG: ProfileRemoteDataSource avatar_url: ${userMap['avatar_url']}');

    if (userMap['id'] == null || userMap['email'] == null) {
      print(
          'ERROR: ProfileRemoteDataSource missing id or email in userMap: $userMap');
      throw const FormatException(
          'User profile missing required fields (id/email)');
    }

    // AVOID REDIRECT LOOP: Explicitly check for both keys and percentage
    // 1. Check percentage if available in nested or root data
    Map<String, dynamic>? profileCompletion;
    if (data['data'] is Map<String, dynamic>) {
      profileCompletion =
          data['data']['profileCompletion'] as Map<String, dynamic>?;
    }
    profileCompletion ??= data['profileCompletion'] as Map<String, dynamic>?;

    if (profileCompletion != null) {
      final percentage = profileCompletion['percentage'] as num? ?? 0;
      print(
          'DEBUG: ProfileRemoteDataSource profileCompletion percentage=$percentage');
      if (percentage >= 100) {
        userMap['profile_setup_complete'] = true;
        print(
            'DEBUG: Overriding profileSetupComplete=true due to 100% completion');
      }
    } else {
      print(
          'DEBUG: ProfileRemoteDataSource NO profileCompletion found in response');
    }

    // 2. Handle both snake_case and camelCase from API
    if (userMap['profileSetupComplete'] == true) {
      userMap['profile_setup_complete'] = true;
    }

    try {
      return UserDto.fromJson(userMap);
    } catch (e, stack) {
      print('ERROR: ProfileRemoteDataSource DTO parsing failed: $e');
      print('Stack trace: $stack');
      print('Bad UserMap: $userMap');

      if (e is TypeError) {
        throw const FormatException(
            'User profile data has invalid types (likely null in required String field)');
      }
      rethrow;
    }
  }

  Future<UserDto> updateProfile(UpdateProfileParams params) async {
    print('DEBUG: ProfileRemoteDataSource updating with: ${params.firstName}');
    final response = await _dio.patch(
      '/users/me',
      data: {
        if (params.firstName != null) 'first_name': params.firstName,
        if (params.lastName != null) 'last_name': params.lastName,
        if (params.phoneNumber != null) 'phone_number': params.phoneNumber,
        if (params.avatarUrl != null) 'avatar_url': params.avatarUrl,
        if (params.isProfileComplete != null)
          'profile_setup_complete': params.isProfileComplete,
      },
    );
    print(
        'DEBUG: ProfileRemoteDataSource update response raw: ${response.data}');

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException('Invalid response format: $data');
    }

    Map<String, dynamic>? userMap;
    if (data['data'] is Map<String, dynamic>) {
      final innerData = data['data'] as Map<String, dynamic>;
      if (innerData['user'] is Map<String, dynamic>) {
        userMap = innerData['user'] as Map<String, dynamic>;
      } else {
        userMap = innerData;
      }
    } else {
      userMap = data;
    }

    return UserDto.fromJson(userMap);
  }
}
