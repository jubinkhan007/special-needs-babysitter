import 'package:json_annotation/json_annotation.dart';

part 'application_detail_dto.g.dart';

/// Child DTO for application details.
@JsonSerializable()
class ChildDto {
  final String id;
  final String firstName;
  final String lastName;
  final int? age;
  final String? specialNeedsDiagnosis;
  final String? personalityDescription;
  final String? medicationDietaryNeeds;
  final bool? hasAllergies;
  final List<String>? allergyTypes;
  final bool? hasTriggers;
  final List<String>? triggerTypes;
  final String? triggers;
  final String? calmingMethods;
  final List<String>? transportationModes;
  final List<String>? equipmentSafety;
  final bool? needsDropoff;
  final String? pickupLocation;
  final String? dropoffLocation;
  final String? transportSpecialInstructions;

  const ChildDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.age,
    this.specialNeedsDiagnosis,
    this.personalityDescription,
    this.medicationDietaryNeeds,
    this.hasAllergies,
    this.allergyTypes,
    this.hasTriggers,
    this.triggerTypes,
    this.triggers,
    this.calmingMethods,
    this.transportationModes,
    this.equipmentSafety,
    this.needsDropoff,
    this.pickupLocation,
    this.dropoffLocation,
    this.transportSpecialInstructions,
  });

  factory ChildDto.fromJson(Map<String, dynamic> json) =>
      _$ChildDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChildDtoToJson(this);
}

/// Job DTO for application details.
@JsonSerializable()
class JobDetailDto {
  final String id;
  final String title;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final double? payRate;
  final String? status;
  final String? additionalDetails;
  final int? estimatedDuration;
  final double? estimatedTotal;
  final String? location;
  final String? fullAddress;
  final double? distance;
  final String? familyName;
  final String? familyPhotoUrl;
  final int? childrenCount;
  final List<ChildDto>? children;
  final List<String>? requiredSkills;

  const JobDetailDto({
    required this.id,
    required this.title,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.payRate,
    this.status,
    this.additionalDetails,
    this.estimatedDuration,
    this.estimatedTotal,
    this.location,
    this.fullAddress,
    this.distance,
    this.familyName,
    this.familyPhotoUrl,
    this.childrenCount,
    this.children,
    this.requiredSkills,
  });

  factory JobDetailDto.fromJson(Map<String, dynamic> json) =>
      _$JobDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailDtoToJson(this);
}

/// Sitter DTO for application details (reusing structure from applications list).
@JsonSerializable()
class ApplicationSitterDto {
  final String userId;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? bio;
  final double? hourlyRate;
  final String? yearsOfExperience;
  final int? reliabilityScore;
  final List<String>? skills;

  const ApplicationSitterDto({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.bio,
    this.hourlyRate,
    this.yearsOfExperience,
    this.reliabilityScore,
    this.skills,
  });

  factory ApplicationSitterDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSitterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationSitterDtoToJson(this);

  String get fullName => '$firstName $lastName';
}

/// Application detail DTO.
@JsonSerializable()
class ApplicationDetailDto {
  final String id;
  final String status;
  final bool isInvitation;
  final String? coverLetter;
  final String? declineReason;
  final String? declineOtherReason;
  final String? cancellationReason;
  final bool? hasMoreShifts;
  final String? createdAt;
  final String? invitedAt;
  final String? acceptedAt;
  final String? declinedAt;
  final String? withdrawnAt;
  final String? completedAt;
  final String? cancelledAt;
  final JobDetailDto job;
  final ApplicationSitterDto? sitter;

  const ApplicationDetailDto({
    required this.id,
    required this.status,
    required this.isInvitation,
    this.coverLetter,
    this.declineReason,
    this.declineOtherReason,
    this.cancellationReason,
    this.hasMoreShifts,
    this.createdAt,
    this.invitedAt,
    this.acceptedAt,
    this.declinedAt,
    this.withdrawnAt,
    this.completedAt,
    this.cancelledAt,
    required this.job,
    this.sitter,
  });

  factory ApplicationDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDetailDtoToJson(this);
}

/// Response DTO for GET /applications/{id}.
@JsonSerializable()
class ApplicationDetailResponseDto {
  final bool success;
  final ApplicationDetailDto data;

  const ApplicationDetailResponseDto({
    required this.success,
    required this.data,
  });

  factory ApplicationDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDetailResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDetailResponseDtoToJson(this);
}
