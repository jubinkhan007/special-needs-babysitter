import 'dart:io';
import 'package:dio/dio.dart';

class ProfileDetailsPresignedUrlResponse {
  final String uploadUrl;
  final String publicUrl;

  ProfileDetailsPresignedUrlResponse(
      {required this.uploadUrl, required this.publicUrl,});

  factory ProfileDetailsPresignedUrlResponse.fromJson(
      Map<String, dynamic> json,) {
    return ProfileDetailsPresignedUrlResponse(
      uploadUrl: json['uploadUrl'],
      publicUrl: json['publicUrl'],
    );
  }
}

class ProfileDetailsRemoteDataSource {
  final Dio _dio;

  ProfileDetailsRemoteDataSource(this._dio);

  Future<void> updateProfileDetails(Map<String, dynamic> data,
      {int step = 1,}) async {
    try {
      print(
          'DEBUG: RemoteDataSource updating profile (step $step) with data: $data',);
      await _dio.put(
        '/parents/me',
        data: {
          'step': step,
          'data': data,
        },
      );
    } catch (e) {
      print('DEBUG: Error updating profile: $e');
      rethrow;
    }
  }

  /// PUT /parents/me (for file upload - if needed separate, but usually handled by same endpoint or presigned)
  /// For this task, we stick to the JSON update.

  /// POST /uploads/presign
  Future<ProfileDetailsPresignedUrlResponse> getPresignedUrl({
    required String fileName,
    required String contentType,
  }) async {
    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType': 'profile-photo', // specific type for profile photos
        'fileName': fileName,
        'contentType': contentType,
      },
    );

    final data = response.data['data'];
    return ProfileDetailsPresignedUrlResponse.fromJson(data);
  }

  /// Uploads binary file to the presigned URL
  Future<void> uploadFileToUrl(
      String url, File file, String contentType,) async {
    final len = await file.length();
    await _dio.put(
      url,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentLengthHeader: len,
          Headers.contentTypeHeader: contentType,
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getExtendedProfileDetails(String userId) async {
    try {
      print('DEBUG: ProfileDetailsRemoteDataSource requesting /parents/me');
      final response = await _dio.get('/parents/me');
      print(
          'DEBUG: ProfileDetailsRemoteDataSource response status: ${response.statusCode}',);
      print(
          'DEBUG: ProfileDetailsRemoteDataSource response data: ${response.data}',);

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to load profile details - Success flag is false',);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addChild(Map<String, dynamic> childData) async {
    final response = await _dio.post(
      '/children',
      data: childData,
    );
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw Exception('Failed to add child');
    }
  }

  Future<Map<String, dynamic>> getChild(String childId) async {
    final response = await _dio.get('/children/$childId');
    if (response.data['success'] == true) {
      return response.data['data']['child'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get child');
    }
  }

  Future<void> updateChild(
      String childId, Map<String, dynamic> childData,) async {
    try {
      print('DEBUG: updateChild payload: $childData');
      final response = await _dio.put(
        '/children/$childId',
        data: childData,
      );
      if (response.data['success'] != true) {
        throw Exception('Failed to update child');
      }
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: updateChild DioError: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> deleteChild(String childId) async {
    try {
      final response = await _dio.delete('/children/$childId');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete child');
      }
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: deleteChild DioError: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
