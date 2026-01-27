import 'package:json_annotation/json_annotation.dart';

part 'booking_details_dto.g.dart';

@JsonSerializable()
class BookingDetailsResponseDto {
  final bool success;
  final BookingDetailsDto data;

  BookingDetailsResponseDto({
    required this.success,
    required this.data,
  });

  factory BookingDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsResponseDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsDto {
  final String id;
  final String status;
  final String? applicationType;
  final String? clockInTime; // Nullable as per JSON example
  final bool? isPaused;
  final BookingDetailsSitterDto? sitter;
  final BookingDetailsJobDto? job;
  final BookingDetailsFamilyDto? family;
  final List<dynamic>? routeCoordinates;

  BookingDetailsDto({
    required this.id,
    required this.status,
    this.applicationType,
    this.clockInTime,
    this.isPaused,
    this.sitter,
    this.job,
    this.family,
    this.routeCoordinates,
  });

  factory BookingDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsSitterDto {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final int? reliabilityScore;
  final int? responseRate;
  final String? yearsOfExperience;
  final List<String>? skills;
  final String? distance; // "2 Miles Away" or null
  @JsonKey(fromJson: _parseStringFromMap)
  final String? currentLocation;

  BookingDetailsSitterDto({
    required this.userId,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.reliabilityScore,
    this.responseRate,
    this.yearsOfExperience,
    this.skills,
    this.distance,
    this.currentLocation,
  });

  factory BookingDetailsSitterDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsSitterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsSitterDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsJobDto {
  final String id;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final double? payRate;
  final int? numberOfDays;
  final String? additionalDetails;
  final String? fullAddress;
  @JsonKey(fromJson: _parseStringFromMap)
  final String? location;
  final BookingDetailsCoordinatesDto? coordinates;

  BookingDetailsJobDto({
    required this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.payRate,
    this.numberOfDays,
    this.additionalDetails,
    this.fullAddress,
    this.location,
    this.coordinates,
  });

  factory BookingDetailsJobDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsJobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsJobDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsCoordinatesDto {
  final double? latitude;
  final double? longitude;

  BookingDetailsCoordinatesDto({this.latitude, this.longitude});

  factory BookingDetailsCoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsCoordinatesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsCoordinatesDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsFamilyDto {
  final String? familyName;
  final int? childrenCount;

  BookingDetailsFamilyDto({this.familyName, this.childrenCount});

  factory BookingDetailsFamilyDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsFamilyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsFamilyDtoToJson(this);
}

String? _parseStringFromMap(dynamic value) {
  if (value is String) {
    return value;
  }
  return null;
}