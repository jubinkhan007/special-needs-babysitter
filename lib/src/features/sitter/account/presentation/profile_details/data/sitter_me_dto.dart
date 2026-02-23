import 'package:json_annotation/json_annotation.dart';

part 'sitter_me_dto.g.dart';

@JsonSerializable()
class SitterMeResponseDto {
  final bool success;
  final SitterMeDataDto data;

  SitterMeResponseDto({required this.success, required this.data});

  factory SitterMeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SitterMeResponseDtoFromJson(json);
}

@JsonSerializable()
class SitterMeDataDto {
  final SitterMeProfileDto profile;
  final int setupStep;
  final bool setupCompleted;

  SitterMeDataDto({
    required this.profile,
    required this.setupStep,
    required this.setupCompleted,
  });

  factory SitterMeDataDto.fromJson(Map<String, dynamic> json) =>
      _$SitterMeDataDtoFromJson(json);
}

@JsonSerializable()
class SitterMeProfileDto {
  final String id;
  final String? photoUrl;
  final String? bio;
  final String? dateOfBirth;
  final String? yearsOfExperience;
  final double? hourlyRate;
  final bool? openToNegotiating;
  final bool? hasTransportation;
  final String? transportationDetails;
  final bool? willingToTravel;
  final bool? overnightAvailable;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? resumeUrl;
  final List<String>? skills;
  final List<SitterCertificationDto>? certifications;
  final List<String>? ageRanges;
  final List<String>? languages;
  final List<SitterExperienceDto>? experiences;
  final List<SitterAvailabilityDto>? availability;

  SitterMeProfileDto({
    required this.id,
    this.photoUrl,
    this.bio,
    this.dateOfBirth,
    this.yearsOfExperience,
    this.hourlyRate,
    this.openToNegotiating,
    this.hasTransportation,
    this.transportationDetails,
    this.willingToTravel,
    this.overnightAvailable,
    this.address,
    this.latitude,
    this.longitude,
    this.resumeUrl,
    this.skills,
    this.certifications,
    this.ageRanges,
    this.languages,
    this.experiences,
    this.availability,
  });

  factory SitterMeProfileDto.fromJson(Map<String, dynamic> json) =>
      _$SitterMeProfileDtoFromJson(json);
}

@JsonSerializable()
class SitterCertificationDto {
  final String type;
  final String status;

  SitterCertificationDto({required this.type, required this.status});

  factory SitterCertificationDto.fromJson(Map<String, dynamic> json) =>
      _$SitterCertificationDtoFromJson(json);
}

@JsonSerializable()
class SitterExperienceDto {
  final String id;
  final String role;
  final String startMonth;
  final String startYear;
  final String? endMonth;
  final String? endYear;
  final String? description;

  SitterExperienceDto({
    required this.id,
    required this.role,
    required this.startMonth,
    required this.startYear,
    this.endMonth,
    this.endYear,
    this.description,
  });

  factory SitterExperienceDto.fromJson(Map<String, dynamic> json) =>
      _$SitterExperienceDtoFromJson(json);
}

@JsonSerializable()
class SitterAvailabilityDto {
  final String date;
  final String startTime;
  final String endTime;
  final bool noBookings;

  SitterAvailabilityDto({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.noBookings,
  });

  factory SitterAvailabilityDto.fromJson(Map<String, dynamic> json) =>
      _$SitterAvailabilityDtoFromJson(json);
}
