// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: _readPhone(json, 'phoneNumber') as String?,
      avatarUrl: _readAvatarUrl(json, 'avatarUrl') as String?,
      role: json['role'] as String? ?? 'parent',
      isProfileComplete:
          _readProfileComplete(json, 'isProfileComplete') as bool? ?? false,
      isSitterApproved: json['phoneVerified'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'avatarUrl': instance.avatarUrl,
      'role': instance.role,
      'isProfileComplete': instance.isProfileComplete,
      'phoneVerified': instance.isSitterApproved,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
