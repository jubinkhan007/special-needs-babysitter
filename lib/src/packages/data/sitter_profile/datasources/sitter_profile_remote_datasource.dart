import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Response from presigned URL endpoint.
class SitterPresignedUrlResponse {
  final String uploadUrl;
  final String publicUrl;

  SitterPresignedUrlResponse(
      {required this.uploadUrl, required this.publicUrl,});

  factory SitterPresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return SitterPresignedUrlResponse(
      uploadUrl: json['uploadUrl'],
      publicUrl: json['publicUrl'],
    );
  }
}

/// Remote data source for sitter profile API calls.
class SitterProfileRemoteDataSource {
  final Dio _dio;

  SitterProfileRemoteDataSource(this._dio);

  /// PUT /sitters/me
  /// Updates sitter profile for a specific step.
  Future<void> updateSitterProfile({
    required int step,
    required Map<String, dynamic> data,
  }) async {
    try {
      debugPrint(
          'DEBUG: SitterProfileRemoteDataSource updating step=$step with data=$data',);
      final response = await _dio.put(
        '/sitters/me',
        data: {
          'step': step,
          'data': data,
        },
      );
      debugPrint('DEBUG REMOTE: SitterProfileRemoteDataSource step=$step succeeded');
      debugPrint('DEBUG REMOTE: Response status: ${response.statusCode}');
      debugPrint('DEBUG REMOTE: Response data: ${response.data}');
    } catch (e) {
      debugPrint('DEBUG REMOTE: SitterProfileRemoteDataSource error: $e');
      if (e is DioException) {
        debugPrint('DEBUG REMOTE: DioError data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// POST /uploads/presign
  /// Gets presigned URL for file upload.
  /// [uploadType] can be: 'profile-photo', 'resume', 'certification'
  Future<SitterPresignedUrlResponse> getPresignedUrl({
    required String fileName,
    required String contentType,
    required String uploadType,
  }) async {
    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType': uploadType,
        'fileName': fileName,
        'contentType': contentType,
      },
    );

    final data = response.data['data'];
    return SitterPresignedUrlResponse.fromJson(data);
  }

  /// Uploads binary file to the presigned URL.
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
}
