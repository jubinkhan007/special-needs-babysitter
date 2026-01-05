import '../entities/user.dart';

/// Parameters for updating user profile
class UpdateProfileParams {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? avatarUrl;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.avatarUrl,
  });
}

/// Contract for profile repository
abstract interface class ProfileRepository {
  /// Get current authenticated user's profile
  Future<User> getMe();

  /// Update user profile
  Future<User> updateProfile(UpdateProfileParams params);
}
