import 'dart:io';

abstract class ParentProfileRepository {
  /// Updates the parent profile for a specific step.
  ///
  /// [step] - The current step number (e.g., 1).
  /// [data] - The data payload to update.
  /// [profilePhoto] - Optional profile photo file to upload (for Step 1).
  Future<void> updateProfile({
    required int step,
    required Map<String, dynamic> data,
    File? profilePhoto,
  });

  /// Adds or updates a child profile.
  ///
  /// [childData] - The map containing child details.
  Future<void> addUpdateChild(Map<String, dynamic> childData);

  /// Marks the current user's profile as complete on the user record.
  Future<void> markProfileComplete();
}
