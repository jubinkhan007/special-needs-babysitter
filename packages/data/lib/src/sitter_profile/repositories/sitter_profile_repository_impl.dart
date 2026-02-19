import 'dart:io';
import 'package:domain/domain.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

import '../datasources/sitter_profile_remote_datasource.dart';
import 'package:flutter/foundation.dart';

/// Implementation of [SitterProfileRepository].
class SitterProfileRepositoryImpl implements SitterProfileRepository {
  final SitterProfileRemoteDataSource _remoteDataSource;

  SitterProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> updateProfile({
    required int step,
    required Map<String, dynamic> data,
    File? profilePhoto,
    File? resume,
    List<CertificationFile>? certificationFiles,
  }) async {
    try {
      // Handle Step 1: Profile Photo Upload
      if (step == 1 && profilePhoto != null) {
        debugPrint('DEBUG SITTER REPO: Step 1 with photo, starting upload...');
        final photoUrl = await _uploadFile(
          file: profilePhoto,
          uploadType: 'profile-photo',
          filePrefix: 'sitter_photo',
        );
        data['photoUrl'] = photoUrl;
      }

      // Handle Step 5: Resume Upload
      if (step == 5 && resume != null) {
        debugPrint('DEBUG SITTER REPO: Step 5 with resume, starting upload...');
        final resumeUrl = await _uploadFile(
          file: resume,
          uploadType: 'resume',
          filePrefix: 'sitter_resume',
        );
        data['resumeUrl'] = resumeUrl;
      }

      // Handle Step 6: Certification Documents Upload
      if (step == 6 &&
          certificationFiles != null &&
          certificationFiles.isNotEmpty) {
        debugPrint(
            'DEBUG SITTER REPO: Step 6 with ${certificationFiles.length} certifications...',);
        final List<Map<String, dynamic>> certDocs = [];

        for (final certFile in certificationFiles) {
          final fileUrl = await _uploadFile(
            file: certFile.file,
            uploadType: 'certification',
            filePrefix:
                'sitter_cert_${certFile.type.replaceAll(' ', '_').toLowerCase()}',
          );
          certDocs.add({
            'type': certFile.type,
            'fileUrl': fileUrl,
          });
        }

        data['certificationDocuments'] = certDocs;
      }

      // Call API to update sitter profile for this step
      debugPrint(
          'DEBUG SITTER REPO: Calling updateSitterProfile step=$step, data=$data',);
      await _remoteDataSource.updateSitterProfile(step: step, data: data);
      debugPrint('DEBUG SITTER REPO: updateSitterProfile step=$step succeeded');
      return data;
    } catch (e, st) {
      debugPrint('DEBUG SITTER REPO: Error in updateProfile step=$step: $e');
      debugPrint('DEBUG SITTER REPO: Stack trace: $st');
      rethrow;
    }
  }

  /// Uploads a file and returns the public URL.
  Future<String> _uploadFile({
    required File file,
    required String uploadType,
    required String filePrefix,
  }) async {
    final extension = path.extension(file.path).replaceAll('.', '');
    final contentType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final fileName =
        '${filePrefix}_${DateTime.now().millisecondsSinceEpoch}.$extension';

    debugPrint(
        'DEBUG SITTER REPO: Getting presigned URL for $fileName ($uploadType)',);
    final presignRes = await _remoteDataSource.getPresignedUrl(
      fileName: fileName,
      contentType: contentType,
      uploadType: uploadType,
    );
    debugPrint('DEBUG SITTER REPO: Got presigned URL, uploading file...');

    await _remoteDataSource.uploadFileToUrl(
      presignRes.uploadUrl,
      file,
      contentType,
    );
    debugPrint(
        'DEBUG SITTER REPO: File uploaded successfully: ${presignRes.publicUrl}',);

    return presignRes.publicUrl;
  }
}
