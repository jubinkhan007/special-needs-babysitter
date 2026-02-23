// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseSittersResponseDto _$BrowseSittersResponseDtoFromJson(
  Map<String, dynamic> json,
) => BrowseSittersResponseDto(
  success: json['success'] as bool? ?? false,
  data: BrowseSittersDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BrowseSittersResponseDtoToJson(
  BrowseSittersResponseDto instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

BrowseSittersDataDto _$BrowseSittersDataDtoFromJson(
  Map<String, dynamic> json,
) => BrowseSittersDataDto(
  sitters: (json['sitters'] as List<dynamic>)
      .map((e) => SitterDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$BrowseSittersDataDtoToJson(
  BrowseSittersDataDto instance,
) => <String, dynamic>{
  'sitters': instance.sitters,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
  'hasMore': instance.hasMore,
};

SitterDto _$SitterDtoFromJson(Map<String, dynamic> json) => SitterDto(
  id: json['id'] as String,
  userId: json['userId'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  photoUrl: json['photoUrl'] as String,
  bio: json['bio'] as String,
  hourlyRate: (json['hourlyRate'] as num).toDouble(),
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  ageRanges: (json['ageRanges'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  address: json['address'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
  avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
  reliabilityScore: (json['reliabilityScore'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  isSaved: json['isSaved'] as bool? ?? false,
);

Map<String, dynamic> _$SitterDtoToJson(SitterDto instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'photoUrl': instance.photoUrl,
  'bio': instance.bio,
  'hourlyRate': instance.hourlyRate,
  'skills': instance.skills,
  'ageRanges': instance.ageRanges,
  'address': instance.address,
  'distance': instance.distance,
  'avgRating': instance.avgRating,
  'reliabilityScore': instance.reliabilityScore,
  'reviewCount': instance.reviewCount,
  'isSaved': instance.isSaved,
};
