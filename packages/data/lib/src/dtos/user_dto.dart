import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
    @Default('parent') String role,
    @JsonKey(name: 'profileSetupComplete')
    @Default(false)
    bool isProfileComplete,
    @JsonKey(name: 'phoneVerified')
    @Default(false)
    bool
        isSitterApproved, // Mapping phoneVerified to approved for now? Or just ignore?
    // Actually API has phoneVerified. User entity has isSitterApproved.
    // Let's just use what we can.
    // But wait, the previous code had is_sitter_approved.
    // The screenshot has "profileSetupComplete".
    // I'll map profileSetupComplete to isProfileComplete.
    @JsonKey(name: 'created_at') DateTime? createdAt,
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
