// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitterProfileResponseDto _$SitterProfileResponseDtoFromJson(
        Map<String, dynamic> json) =>
    SitterProfileResponseDto(
      success: json['success'] as bool,
      data: SitterProfileDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SitterProfileResponseDtoToJson(
        SitterProfileResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SitterProfileDataDto _$SitterProfileDataDtoFromJson(
        Map<String, dynamic> json) =>
    SitterProfileDataDto(
      profile:
          SitterProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SitterProfileDataDtoToJson(
        SitterProfileDataDto instance) =>
    <String, dynamic>{
      'profile': instance.profile,
    };

SitterProfileDto _$SitterProfileDtoFromJson(Map<String, dynamic> json) =>
    SitterProfileDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      openToNegotiating: json['openToNegotiating'] as bool?,
      distance: (json['distance'] as num?)?.toDouble(),
      address: json['address'] as String?,
      travelRadiusMiles: (json['travelRadiusMiles'] as num?)?.toDouble(),
      hasTransportation: json['hasTransportation'] as bool? ?? false,
      transportationType: json['transportationType'] as String?,
      willingToTravel: json['willingToTravel'] as bool?,
      overnightAvailable: json['overnightAvailable'] as bool?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ageRanges: (json['ageRanges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      experiences: json['experiences'] as List<dynamic>?,
      yearsOfExperience: json['yearsOfExperience'] as String?,
      reliabilityScore: (json['reliabilityScore'] as num?)?.toDouble() ?? 100.0,
      totalJobs: (json['totalJobs'] as num?)?.toInt(),
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      jobTypesAccepted:
          (json['jobTypesAccepted'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      reviews: json['reviews'] as List<dynamic>?,
      availability: json['availability'] as List<dynamic>?,
    );

Map<String, dynamic> _$SitterProfileDtoToJson(SitterProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'hourlyRate': instance.hourlyRate,
      'openToNegotiating': instance.openToNegotiating,
      'distance': instance.distance,
      'address': instance.address,
      'travelRadiusMiles': instance.travelRadiusMiles,
      'hasTransportation': instance.hasTransportation,
      'transportationType': instance.transportationType,
      'willingToTravel': instance.willingToTravel,
      'overnightAvailable': instance.overnightAvailable,
      'skills': instance.skills,
      'ageRanges': instance.ageRanges,
      'languages': instance.languages,
      'certifications': instance.certifications,
      'experiences': instance.experiences,
      'yearsOfExperience': instance.yearsOfExperience,
      'reliabilityScore': instance.reliabilityScore,
      'totalJobs': instance.totalJobs,
      'avgRating': instance.avgRating,
      'reviewCount': instance.reviewCount,
      'jobTypesAccepted': instance.jobTypesAccepted,
      'reviews': instance.reviews,
      'availability': instance.availability,
    };
