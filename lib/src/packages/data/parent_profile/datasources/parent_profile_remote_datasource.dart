import 'dart:io';
import 'package:dio/dio.dart';

class PresignedUrlResponse {
  final String uploadUrl;
  final String publicUrl;

  PresignedUrlResponse({required this.uploadUrl, required this.publicUrl});

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponse(
      uploadUrl: json['uploadUrl'],
      publicUrl: json['publicUrl'],
    );
  }
}

class ParentProfileRemoteDataSource {
  final Dio _dio;

  ParentProfileRemoteDataSource(this._dio);

  /// PUT /parents/me
  /// Used for updating profile steps (1, 2, 3, 4)
  Future<void> updateParentProfile({
    required int step,
    required Map<String, dynamic> data,
  }) async {
    await _dio.put(
      '/parents/me',
      data: {
        'step': step,
        'data': data,
      },
    );
  }

  /// POST /children
  /// Used for adding a new child
  Future<void> addChild(Map<String, dynamic> childData) async {
    await _dio.post(
      '/children',
      data: childData,
    );
  }

  /// POST /uploads/presign
  Future<PresignedUrlResponse> getPresignedUrl({
    required String fileName,
    required String contentType,
  }) async {
    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType':
            'profile-photo', // Required by backend per working implementation
        'fileName': fileName,
        'contentType': contentType,
      },
    );

    // Assuming response format: { success: true, data: { uploadUrl: ..., publicUrl: ... } }
    final data = response.data['data'];
    return PresignedUrlResponse.fromJson(data);
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

  /// PATCH /users/me
  /// Used to explicitly mark profile as complete
  Future<void> markProfileComplete() async {
    await _dio.patch(
      '/users/me',
      data: {
        'profileSetupComplete': true,
        'profile_setup_complete': true,
      },
    );
  }
}
