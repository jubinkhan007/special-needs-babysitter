import 'package:json_annotation/json_annotation.dart';

part 'sitter_profile_dto.g.dart';

@JsonSerializable()
class SitterProfileResponseDto {
  final bool success;
  final SitterProfileDataDto data;

  SitterProfileResponseDto({required this.success, required this.data});

  factory SitterProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SitterProfileResponseDtoFromJson(json);
}

@JsonSerializable()
class SitterProfileDataDto {
  final SitterProfileDto profile;

  SitterProfileDataDto({required this.profile});

  factory SitterProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$SitterProfileDataDtoFromJson(json);
}

@JsonSerializable()
class SitterProfileDto {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? bio;
  final double hourlyRate;
  final bool? openToNegotiating; // Added
  final double? distance;
  final String? address; // Added
  final double? travelRadiusMiles;
  final bool hasTransportation;
  final String? transportationType;
  final bool? willingToTravel; // Added
  final bool? overnightAvailable; // Added
  final List<String> skills;
  final List<String> ageRanges;
  final List<String> languages;
  final List<String> certifications;
  final List<dynamic>? experiences; // Added
  final String? yearsOfExperience;
  final double reliabilityScore;
  final int? totalJobs; // Added
  final double avgRating;
  final int reviewCount;
  final Map<String, bool>? jobTypesAccepted;

  // reviews and availability are lists in JSON, but strict typing might need specific DTOs
  // For now leaving them as dynamic or ignored if not needed for the immediate UI mapping
  // The UI model SitterModel doesn't have structure for full reviews list or availability grid yet for this screen
  // But let's add them as basic lists to avoid data loss if needed later
  final List<dynamic>? reviews;
  final List<dynamic>? availability;

  SitterProfileDto({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.bio,
    this.hourlyRate = 0.0,
    this.openToNegotiating,
    this.distance,
    this.address,
    this.travelRadiusMiles,
    this.hasTransportation = false,
    this.transportationType,
    this.willingToTravel,
    this.overnightAvailable,
    this.skills = const [],
    this.ageRanges = const [],
    this.languages = const [],
    this.certifications = const [],
    this.experiences,
    this.yearsOfExperience,
    this.reliabilityScore = 100.0,
    this.totalJobs,
    this.avgRating = 0.0,
    this.reviewCount = 0,
    this.jobTypesAccepted,
    this.reviews,
    this.availability,
  });

  factory SitterProfileDto.fromJson(Map<String, dynamic> json) =>
      _$SitterProfileDtoFromJson(json);
}
