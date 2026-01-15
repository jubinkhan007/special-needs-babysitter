import 'package:json_annotation/json_annotation.dart';

part 'application_dto.g.dart';

/// DTO for sitter information in an application.
@JsonSerializable()
class SitterDto {
  final String userId;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? bio;
  final double? hourlyRate;
  final String? yearsOfExperience;
  final int? reliabilityScore;
  final List<String>? skills;

  const SitterDto({
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

  factory SitterDto.fromJson(Map<String, dynamic> json) =>
      _$SitterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SitterDtoToJson(this);

  String get fullName => '$firstName $lastName';

  /// Use userId as the sitter's ID
  String get id => userId;
}

/// DTO for a single application.
@JsonSerializable()
class ApplicationDto {
  final String id;
  final String status;
  final bool isInvitation;
  final String? coverLetter;
  final SitterDto sitter;

  const ApplicationDto({
    required this.id,
    required this.status,
    required this.isInvitation,
    this.coverLetter,
    required this.sitter,
  });

  factory ApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDtoToJson(this);
}

/// DTO for the applications response data.
@JsonSerializable()
class ApplicationsDataDto {
  final List<ApplicationDto> applications;
  final int total;

  const ApplicationsDataDto({
    required this.applications,
    required this.total,
  });

  factory ApplicationsDataDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationsDataDtoToJson(this);
}

/// DTO for the full API response.
@JsonSerializable()
class ApplicationsResponseDto {
  final bool success;
  final ApplicationsDataDto data;

  const ApplicationsResponseDto({
    required this.success,
    required this.data,
  });

  factory ApplicationsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationsResponseDtoToJson(this);
}
