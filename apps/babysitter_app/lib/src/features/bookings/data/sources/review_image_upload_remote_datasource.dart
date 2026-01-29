import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

/// Handles uploading review photos via the presigned uploads endpoint.
class ReviewImageUploadRemoteDataSource {
  final Dio _dio;
  final Dio _uploadDio;

  ReviewImageUploadRemoteDataSource(this._dio) : _uploadDio = Dio();

  Future<String> uploadReviewImage(File file) async {
    final fileName = path.basename(file.path);
    final extension = path.extension(fileName).toLowerCase();
    final contentType = _contentTypeFromExtension(extension);

    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType': 'review-image',
        'fileName': fileName,
        'contentType': contentType,
      },
    );

    final data = (response.data['data'] ?? {}) as Map<String, dynamic>;
    final uploadUrl = data['uploadUrl'] as String;
    final publicUrl = data['publicUrl'] as String;

    final length = await file.length();
    await _uploadDio.put(
      uploadUrl,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentLengthHeader: length,
          Headers.contentTypeHeader: contentType,
        },
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    return publicUrl;
  }

  String _contentTypeFromExtension(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
