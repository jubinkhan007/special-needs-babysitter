import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_dto.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    required UserDto user,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);
}
