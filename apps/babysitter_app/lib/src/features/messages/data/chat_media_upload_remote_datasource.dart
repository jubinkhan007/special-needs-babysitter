import 'dart:io';

import 'package:dio/dio.dart';

class ChatMediaUploadResult {
  final String publicUrl;
  final String mediaType;
  final String fileName;

  const ChatMediaUploadResult({
    required this.publicUrl,
    required this.mediaType,
    required this.fileName,
  });
}

/// Handles uploading chat attachments via the presigned uploads endpoint.
class ChatMediaUploadRemoteDataSource {
  final Dio _dio;
  final Dio _uploadDio;

  ChatMediaUploadRemoteDataSource(this._dio) : _uploadDio = Dio();

  Future<ChatMediaUploadResult> uploadFile(File file) async {
    final fileName = file.path.split('/').last;
    final extension = _extensionFromFileName(fileName);
    final contentType = _contentTypeFromExtension(extension);
    final mediaType = _mediaTypeFromExtension(extension);

    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType': 'chat-media',
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

    return ChatMediaUploadResult(
      publicUrl: publicUrl,
      mediaType: mediaType,
      fileName: fileName,
    );
  }

  String _extensionFromFileName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return fileName.substring(dotIndex).toLowerCase();
  }

  String _mediaTypeFromExtension(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.webp':
      case '.gif':
      case '.heic':
      case '.heif':
        return 'image';
      case '.mp4':
      case '.mov':
      case '.m4v':
      case '.avi':
      case '.webm':
        return 'video';
      case '.mp3':
      case '.wav':
      case '.m4a':
      case '.aac':
      case '.ogg':
        return 'audio';
      default:
        return 'file';
    }
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
      case '.gif':
        return 'image/gif';
      case '.heic':
      case '.heif':
        return 'image/heic';
      case '.mp4':
      case '.m4v':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.webm':
        return 'video/webm';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      case '.m4a':
        return 'audio/mp4';
      case '.aac':
        return 'audio/aac';
      case '.ogg':
        return 'audio/ogg';
      default:
        return 'application/octet-stream';
    }
  }
}
