import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default('parent') String role,
    @JsonKey(name: 'is_profile_complete')
    @Default(false)
    bool isProfileComplete,
    @JsonKey(name: 'is_sitter_approved') @Default(false) bool isSitterApproved,
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
