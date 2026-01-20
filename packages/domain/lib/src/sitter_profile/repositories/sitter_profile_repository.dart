import 'dart:io';

/// Repository interface for sitter profile operations.
abstract class SitterProfileRepository {
  /// Updates the sitter profile for a specific step.
  ///
  /// [step] - The current step number (1-9).
  /// [data] - The data payload to update.
  /// [profilePhoto] - Optional profile photo file (Step 1).
  /// [resume] - Optional resume file (Step 5).
  /// [certificationFiles] - Optional list of certification files with types (Step 6).
  Future<Map<String, dynamic>> updateProfile({
    required int step,
    required Map<String, dynamic> data,
    File? profilePhoto,
    File? resume,
    List<CertificationFile>? certificationFiles,
  });
}

/// Represents a certification file with its type.
class CertificationFile {
  final String type;
  final File file;

  CertificationFile({required this.type, required this.file});
}
