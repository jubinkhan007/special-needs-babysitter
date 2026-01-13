// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      firstName: (json['firstName'] ?? json['first_name']) as String?,
      lastName: (json['lastName'] ?? json['last_name']) as String?,
      phoneNumber: (json['phoneNumber'] ?? json['phone_number']) as String?,
      avatarUrl: (json['avatarUrl'] ?? json['avatar_url']) as String?,
      role: json['role'] as String? ?? 'parent',
      isProfileComplete: json['profileSetupComplete'] as bool? ?? false,
      isSitterApproved: json['phoneVerified'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
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
      'profileSetupComplete': instance.isProfileComplete,
      'phoneVerified': instance.isSitterApproved,
      'created_at': instance.createdAt?.toIso8601String(),
    };
