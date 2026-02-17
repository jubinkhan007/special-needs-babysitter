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
        print('DEBUG REPO: Step 1 with photo, starting upload...');
        final extension = path.extension(profilePhoto.path).replaceAll('.', '');
        final contentType =
            lookupMimeType(profilePhoto.path) ?? 'image/$extension';
        final fileName =
            'parent_profile_${DateTime.now().millisecondsSinceEpoch}.$extension';

        // Get Presigned URL
        print(
            'DEBUG REPO: Getting presigned URL for $fileName, contentType=$contentType',);
        final presignRes = await _remoteDataSource.getPresignedUrl(
          fileName: fileName,
          contentType: contentType,
        );
        print(
            'DEBUG REPO: Got presigned URL: ${presignRes.uploadUrl}, publicUrl: ${presignRes.publicUrl}',);

        // Upload File
        print('DEBUG REPO: Uploading file...');
        await _remoteDataSource.uploadFileToUrl(
          presignRes.uploadUrl,
          profilePhoto,
          contentType,
        );
        print('DEBUG REPO: File uploaded successfully');

        // Add public URL to data
        data['photoUrl'] = presignRes.publicUrl;
      }

      // 2. Call API to update profile step
      print(
          'DEBUG REPO: Calling updateParentProfile with step=$step, data=$data',);
      await _remoteDataSource.updateParentProfile(step: step, data: data);
      print('DEBUG REPO: updateParentProfile succeeded');
    } catch (e, st) {
      print('DEBUG REPO: Error in updateProfile: $e');
      print('DEBUG REPO: Stack trace: $st');
      rethrow;
    }
  }

  @override
  Future<void> addUpdateChild(Map<String, dynamic> childData) async {
    // Only supporting POST (Add) for now based on requirements
    await _remoteDataSource.addChild(childData);
  }

  @override
  Future<void> markProfileComplete() async {
    await _remoteDataSource.markProfileComplete();
  }
}
