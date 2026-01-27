import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

// Helper functions to read from multiple possible JSON keys
String? _readPhone(Map json, String key) =>
    json['phoneNumber'] as String? ??
    json['phone'] as String? ??
    json['phone_number'] as String?;

String? _readAvatarUrl(Map json, String key) =>
    json['avatarUrl'] as String? ??
    json['avatar_url'] as String? ??
    json['photoUrl'] as String?;

bool _readProfileComplete(Map json, String key) =>
    json['profileSetupComplete'] as bool? ??
    json['profile_setup_complete'] as bool? ??
    false;

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    @JsonKey(readValue: _readPhone) String? phoneNumber,
    @JsonKey(readValue: _readAvatarUrl) String? avatarUrl,
    @Default('parent') String role,
    @JsonKey(readValue: _readProfileComplete)
    @Default(false)
    bool isProfileComplete,
    @JsonKey(name: 'phoneVerified') @Default(false) bool isSitterApproved,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoX on UserDto {
  UserRole get roleEnum {
    switch (role.toLowerCase()) {
      case 'sitter':
        return UserRole.sitter;
      case 'parent':
      default:
        return UserRole.parent;
    }
  }
}
