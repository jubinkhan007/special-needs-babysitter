// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter_me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitterMeResponseDto _$SitterMeResponseDtoFromJson(Map<String, dynamic> json) =>
    SitterMeResponseDto(
      success: json['success'] as bool,
      data: SitterMeDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SitterMeResponseDtoToJson(
        SitterMeResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

SitterMeDataDto _$SitterMeDataDtoFromJson(Map<String, dynamic> json) =>
    SitterMeDataDto(
      profile:
          SitterMeProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
      setupStep: (json['setupStep'] as num).toInt(),
      setupCompleted: json['setupCompleted'] as bool,
    );

Map<String, dynamic> _$SitterMeDataDtoToJson(SitterMeDataDto instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'setupStep': instance.setupStep,
      'setupCompleted': instance.setupCompleted,
    };

SitterMeProfileDto _$SitterMeProfileDtoFromJson(Map<String, dynamic> json) =>
    SitterMeProfileDto(
      id: json['id'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      openToNegotiating: json['openToNegotiating'] as bool?,
      hasTransportation: json['hasTransportation'] as bool?,
      transportationDetails: json['transportationDetails'] as String?,
      willingToTravel: json['willingToTravel'] as bool?,
      overnightAvailable: json['overnightAvailable'] as bool?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      resumeUrl: json['resumeUrl'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map(
              (e) => SitterCertificationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      ageRanges: (json['ageRanges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((e) => SitterExperienceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      availability: (json['availability'] as List<dynamic>?)
          ?.map(
              (e) => SitterAvailabilityDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SitterMeProfileDtoToJson(SitterMeProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'dateOfBirth': instance.dateOfBirth,
      'yearsOfExperience': instance.yearsOfExperience,
      'hourlyRate': instance.hourlyRate,
      'openToNegotiating': instance.openToNegotiating,
      'hasTransportation': instance.hasTransportation,
      'transportationDetails': instance.transportationDetails,
      'willingToTravel': instance.willingToTravel,
      'overnightAvailable': instance.overnightAvailable,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'resumeUrl': instance.resumeUrl,
      'skills': instance.skills,
      'certifications': instance.certifications,
      'ageRanges': instance.ageRanges,
      'languages': instance.languages,
      'experiences': instance.experiences,
      'availability': instance.availability,
    };

SitterCertificationDto _$SitterCertificationDtoFromJson(
        Map<String, dynamic> json) =>
    SitterCertificationDto(
      type: json['type'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$SitterCertificationDtoToJson(
        SitterCertificationDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
    };

SitterExperienceDto _$SitterExperienceDtoFromJson(Map<String, dynamic> json) =>
    SitterExperienceDto(
      id: json['id'] as String,
      role: json['role'] as String,
      startMonth: json['startMonth'] as String,
      startYear: json['startYear'] as String,
      endMonth: json['endMonth'] as String?,
      endYear: json['endYear'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SitterExperienceDtoToJson(
        SitterExperienceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'startMonth': instance.startMonth,
      'startYear': instance.startYear,
      'endMonth': instance.endMonth,
      'endYear': instance.endYear,
      'description': instance.description,
    };

SitterAvailabilityDto _$SitterAvailabilityDtoFromJson(
        Map<String, dynamic> json) =>
    SitterAvailabilityDto(
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      noBookings: json['noBookings'] as bool,
    );

Map<String, dynamic> _$SitterAvailabilityDtoToJson(
        SitterAvailabilityDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'noBookings': instance.noBookings,
    };
