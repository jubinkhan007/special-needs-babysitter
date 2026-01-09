import 'dart:io';
import '../entities/child.dart';
import '../entities/user_profile_details.dart';

abstract class ProfileDetailsRepository {
  Future<UserProfileDetails> getProfileDetails(String userId);
  Future<void> updateProfileDetails(String userId, Map<String, dynamic> data,
      {int step = 1});
  Future<void> addChild(Map<String, dynamic> childData);
  Future<Child> getChild(String childId);
  Future<void> updateChild(String childId, Map<String, dynamic> childData);
  Future<String> uploadProfilePhoto(File file); // Returns publicUrl
}
