import 'package:json_annotation/json_annotation.dart';

part 'parent_booking_dto.g.dart';

@JsonSerializable()
class ParentBookingsResponseDto {
  final List<ParentBookingDto> bookings;
  final int? total;

  ParentBookingsResponseDto({
    required this.bookings,
    this.total,
  });

  factory ParentBookingsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ParentBookingsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParentBookingsResponseDtoToJson(this);
}

@JsonSerializable()
class ParentBookingDto {
  final String id;
  final String status;
  final bool? isInvitation;
  final String? applicationType;
  final String? coverLetter;
  final String? createdAt;
  final String? acceptedAt;
  final String? declinedAt;
  final ParentBookingSitterDto? sitter;
  final ParentBookingJobDto? job;

  ParentBookingDto({
    required this.id,
    required this.status,
    this.isInvitation,
    this.applicationType,
    this.coverLetter,
    this.createdAt,
    this.acceptedAt,
    this.declinedAt,
    this.sitter,
    this.job,
  });

  factory ParentBookingDto.fromJson(Map<String, dynamic> json) =>
      _$ParentBookingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParentBookingDtoToJson(this);
}

@JsonSerializable()
class ParentBookingSitterDto {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final String? bio;
  final double? hourlyRate;
  final int? reliabilityScore;
  final List<String>? skills;
  final String? address;
  final double? latitude;
  final double? longitude;

  ParentBookingSitterDto({
    required this.userId,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.bio,
    this.hourlyRate,
    this.reliabilityScore,
    this.skills,
    this.address,
    this.latitude,
    this.longitude,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory ParentBookingSitterDto.fromJson(Map<String, dynamic> json) =>
      _$ParentBookingSitterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParentBookingSitterDtoToJson(this);
}

@JsonSerializable()
class ParentBookingJobDto {
  final String id;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final double? payRate;
  final String? status;
  final String? location;
  final String? fullAddress;
  final int? childrenCount;
  final String? additionalDetails;
  final List<ParentBookingChildDto>? children;

  ParentBookingJobDto({
    required this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.payRate,
    this.status,
    this.location,
    this.fullAddress,
    this.childrenCount,
    this.additionalDetails,
    this.children,
  });

  factory ParentBookingJobDto.fromJson(Map<String, dynamic> json) =>
      _$ParentBookingJobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParentBookingJobDtoToJson(this);
}

@JsonSerializable()
class ParentBookingChildDto {
  final String id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? specialNeedsDiagnosis;

  ParentBookingChildDto({
    required this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.specialNeedsDiagnosis,
  });

  factory ParentBookingChildDto.fromJson(Map<String, dynamic> json) =>
      _$ParentBookingChildDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParentBookingChildDtoToJson(this);
}
