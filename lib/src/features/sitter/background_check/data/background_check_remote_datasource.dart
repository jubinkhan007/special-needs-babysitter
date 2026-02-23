import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for background check API calls.
class BackgroundCheckRemoteDataSource {
  final Dio _dio;

  BackgroundCheckRemoteDataSource(this._dio);

  /// POST /uploads/presign
  /// Gets presigned URL for identity document upload.
  Future<PresignedUrlResponse> getPresignedUrl({
    required String fileName,
    required String contentType,
  }) async {
    try {
      debugPrint(
          'DEBUG: Requesting presigned URL with fileName=$fileName, contentType=$contentType');
      final response = await _dio.post(
        '/uploads/presign',
        data: {
          'uploadType': 'identity-document',
          'fileName': fileName,
          'contentType': contentType,
        },
      );

      final data = response.data['data'];
      return PresignedUrlResponse.fromJson(data);
    } catch (e) {
      debugPrint('DEBUG: getPresignedUrl error: $e');
      if (e is DioException && e.response != null) {
        debugPrint('DEBUG: Response status: ${e.response?.statusCode}');
        debugPrint('DEBUG: Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// Uploads binary file to the presigned URL.
  Future<void> uploadFileToUrl(
      String url, File file, String contentType) async {
    final len = await file.length();

    // Create a separate Dio instance for S3 upload (no auth headers)
    final uploadDio = Dio();

    await uploadDio.put(
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

  /// POST /sitters/me/background-check/identity
  /// Submits identity verification for background check.
  Future<void> submitIdentityVerification({
    required String documentType,
    required String fileUrl,
  }) async {
    await _dio.post(
      '/sitters/me/background-check/identity',
      data: {
        'documentType': documentType,
        'fileUrl': fileUrl,
      },
    );
  }

  /// GET /sitters/me/background-check
  /// Gets the current background check status.
  Future<Map<String, dynamic>> getBackgroundCheckStatus() async {
    try {
      debugPrint('DEBUG: Fetching background check status');
      final response = await _dio.get('/sitters/me/background-check');
      debugPrint('DEBUG: Background check response: ${response.data}');

      // Extract the data object from the response
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) {
        debugPrint('DEBUG: No data in response, returning not_started');
        return {'status': 'not_started'};
      }

      return data;
    } catch (e) {
      debugPrint('DEBUG: Background check error: $e');
      // If 404, it might mean no record exists -> not started
      if (e is DioException && e.response?.statusCode == 404) {
        return {'status': 'not_started'};
      }
      rethrow;
    }
  }
}

/// Response from presigned URL endpoint.
class PresignedUrlResponse {
  final String uploadUrl;
  final String publicUrl;

  PresignedUrlResponse({
    required this.uploadUrl,
    required this.publicUrl,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponse(
      uploadUrl: json['uploadUrl'],
      publicUrl: json['publicUrl'],
    );
  }
}
