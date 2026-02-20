// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    _AuthSessionDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$AuthSessionDtoToJson(_AuthSessionDto instance) =>
    <String, dynamic>{
      'user': instance.user,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
