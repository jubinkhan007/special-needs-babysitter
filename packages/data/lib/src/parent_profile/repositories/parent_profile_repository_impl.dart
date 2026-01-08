import 'dart:io';
import 'package:domain/domain.dart';
import 'package:path/path.dart' as path;
// ignore: implementation_imports
import 'package:mime/mime.dart'; // Ensure mime package is available or write helper

import '../datasources/parent_profile_remote_datasource.dart';

class ParentProfileRepositoryImpl implements ParentProfileRepository {
  final ParentProfileRemoteDataSource _remoteDataSource;

  ParentProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> updateProfile({
    required int step,
    required Map<String, dynamic> data,
    File? profilePhoto,
  }) async {
    try {
      // 1. Upload Photo if Step 1 and photo exists
      if (step == 1 && profilePhoto != null) {
        final extension = path.extension(profilePhoto.path).replaceAll('.', '');
        final contentType =
            lookupMimeType(profilePhoto.path) ?? 'image/$extension';
        final fileName =
            'parent_profile_${DateTime.now().millisecondsSinceEpoch}.$extension';

        // Get Presigned URL
        final presignRes = await _remoteDataSource.getPresignedUrl(
          fileName: fileName,
          contentType: contentType,
        );

        // Upload File
        await _remoteDataSource.uploadFileToUrl(
          presignRes.uploadUrl,
          profilePhoto,
          contentType,
        );

        // Add public URL to data
        data['photoUrl'] = presignRes.publicUrl;
      }

      // 2. Call API to update profile step
      await _remoteDataSource.updateParentProfile(step: step, data: data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addUpdateChild(Map<String, dynamic> childData) async {
    // Only supporting POST (Add) for now based on requirements
    await _remoteDataSource.addChild(childData);
  }
}
