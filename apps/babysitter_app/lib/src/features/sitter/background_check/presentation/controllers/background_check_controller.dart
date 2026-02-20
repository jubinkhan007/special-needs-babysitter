import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:auth/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../data/background_check_remote_datasource.dart';
import 'package:flutter/foundation.dart';

/// State for background check submission
class BackgroundCheckState {
  final File? selectedFile;
  final String? documentType;
  final bool isLoading;
  final String? error;

  const BackgroundCheckState({
    this.selectedFile,
    this.documentType,
    this.isLoading = false,
    this.error,
  });

  BackgroundCheckState copyWith({
    File? selectedFile,
    String? documentType,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearFile = false,
  }) {
    return BackgroundCheckState(
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),
      documentType: documentType ?? this.documentType,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Document types for identity verification
class DocumentTypes {
  static const String driversLicense = 'drivers_license';
  static const String passport = 'passport';
  static const String stateId = 'state_id';

  static const List<String> all = [driversLicense, passport, stateId];

  static String displayName(String type) {
    switch (type) {
      case driversLicense:
        return "Driver's License";
      case passport:
        return 'Passport';
      case stateId:
        return 'State ID';
      default:
        return type;
    }
  }
}

/// Provider for BackgroundCheckRemoteDataSource
final backgroundCheckRemoteDataSourceProvider =
    Provider<BackgroundCheckRemoteDataSource>((ref) {
  return BackgroundCheckRemoteDataSource(ref.watch(authDioProvider));
});

/// Controller for background check submission
class BackgroundCheckController extends StateNotifier<BackgroundCheckState> {
  final BackgroundCheckRemoteDataSource _dataSource;
  final ImagePicker _imagePicker = ImagePicker();

  BackgroundCheckController(this._dataSource)
      : super(const BackgroundCheckState(
          documentType: DocumentTypes.driversLicense,
        ));

  /// Select document type
  void selectDocumentType(String type) {
    state = state.copyWith(documentType: type, clearError: true);
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        state = state.copyWith(
          selectedFile: File(image.path),
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  /// Take photo with camera
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        state = state.copyWith(
          selectedFile: File(image.path),
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to take photo: $e');
    }
  }

  /// Clear selected file
  void clearFile() {
    state = state.copyWith(clearFile: true, clearError: true);
  }

  /// Submit background check
  /// Returns true on success, false on failure
  Future<bool> submitBackgroundCheck() async {
    if (state.selectedFile == null) {
      state = state.copyWith(error: 'Please select an identity document');
      return false;
    }

    if (state.documentType == null) {
      state = state.copyWith(error: 'Please select a document type');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final file = state.selectedFile!;
      final fileName = path.basename(file.path);
      final extension = path.extension(fileName).toLowerCase();

      // Determine content type
      String contentType;
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          contentType = 'image/jpeg';
          break;
        case '.png':
          contentType = 'image/png';
          break;
        case '.pdf':
          contentType = 'application/pdf';
          break;
        default:
          contentType = 'image/jpeg';
      }

      debugPrint('DEBUG: Getting presigned URL for $fileName');

      // Step 1: Get presigned URL
      final presignedResponse = await _dataSource.getPresignedUrl(
        fileName: fileName,
        contentType: contentType,
      );

      debugPrint('DEBUG: Uploading file to ${presignedResponse.uploadUrl}');

      // Step 2: Upload file to presigned URL
      await _dataSource.uploadFileToUrl(
        presignedResponse.uploadUrl,
        file,
        contentType,
      );

      debugPrint('DEBUG: File uploaded, public URL: ${presignedResponse.publicUrl}');

      // Step 3: Submit identity verification
      await _dataSource.submitIdentityVerification(
        documentType: state.documentType!,
        fileUrl: presignedResponse.publicUrl,
      );

      debugPrint('DEBUG: Background check submitted successfully');

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      debugPrint('DEBUG: Background check submission failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to submit background check. Please try again.',
      );
      return false;
    }
  }
}

/// Provider for BackgroundCheckController
final backgroundCheckControllerProvider =
    StateNotifierProvider<BackgroundCheckController, BackgroundCheckState>(
        (ref) {
  final dataSource = ref.watch(backgroundCheckRemoteDataSourceProvider);
  return BackgroundCheckController(dataSource);
});
