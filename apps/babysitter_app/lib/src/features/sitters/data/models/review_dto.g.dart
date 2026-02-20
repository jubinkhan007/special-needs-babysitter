// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponseDto _$ReviewResponseDtoFromJson(Map<String, dynamic> json) =>
    ReviewResponseDto(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReviewResponseDtoToJson(ReviewResponseDto instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => ReviewDto(
  id: json['_id'] as String,
  jobId: json['jobId'] as String,
  reviewer: json['reviewer'] == null
      ? null
      : ReviewerDto.fromJson(json['reviewer'] as Map<String, dynamic>),
  reviewee: json['reviewee'] == null
      ? null
      : RevieweeDto.fromJson(json['reviewee'] as Map<String, dynamic>),
  reviewerRole: json['reviewerRole'] as String,
  rating: _parseDoubleFromJson(json['rating']),
  reviewText: json['reviewText'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReviewDtoToJson(ReviewDto instance) => <String, dynamic>{
  '_id': instance.id,
  'jobId': instance.jobId,
  'reviewer': instance.reviewer,
  'reviewee': instance.reviewee,
  'reviewerRole': instance.reviewerRole,
  'rating': instance.rating,
  'reviewText': instance.reviewText,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

ReviewerDto _$ReviewerDtoFromJson(Map<String, dynamic> json) => ReviewerDto(
  id: json['id'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$ReviewerDtoToJson(ReviewerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'role': instance.role,
    };

RevieweeDto _$RevieweeDtoFromJson(Map<String, dynamic> json) => RevieweeDto(
  id: json['id'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$RevieweeDtoToJson(RevieweeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'role': instance.role,
    };
