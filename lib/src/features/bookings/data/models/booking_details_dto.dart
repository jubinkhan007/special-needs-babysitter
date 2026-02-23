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
  final String? clockOutTime;
  final bool? isPaused;
  final BookingDetailsSitterDto? sitter;
  final BookingDetailsJobDto? job;
  final String? jobId;
  final BookingDetailsFamilyDto? family;
  final BookingDetailsPaymentDto? payment;
  final List<dynamic>? routeCoordinates;

  BookingDetailsDto({
    required this.id,
    required this.status,
    this.applicationType,
    this.clockInTime,
    this.clockOutTime,
    this.isPaused,
    this.sitter,
    this.job,
    this.jobId,
    this.family,
    this.payment,
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
  @JsonKey(fromJson: _parseIntFromJson)
  final int? reliabilityScore;
  @JsonKey(fromJson: _parseIntFromJson)
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
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? payRate;
  @JsonKey(fromJson: _parseIntFromJson)
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
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? latitude;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? longitude;

  BookingDetailsCoordinatesDto({this.latitude, this.longitude});

  factory BookingDetailsCoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsCoordinatesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsCoordinatesDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsFamilyDto {
  final String? familyName;
  @JsonKey(fromJson: _parseIntFromJson)
  final int? childrenCount;

  BookingDetailsFamilyDto({this.familyName, this.childrenCount});

  factory BookingDetailsFamilyDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsFamilyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsFamilyDtoToJson(this);
}

@JsonSerializable()
class BookingDetailsPaymentDto {
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? hourlyRate;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? estimatedHours;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? estimatedTotal;
  @JsonKey(fromJson: _parseIntFromJson)
  final int? actualMinutesWorked;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? actualHoursWorked;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? actualPayout;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? platformFee;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? totalCharged;
  @JsonKey(fromJson: _parseDoubleFromJson)
  final double? refundAmount;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? clockInTime;
  final String? clockOutTime;

  BookingDetailsPaymentDto({
    this.hourlyRate,
    this.estimatedHours,
    this.estimatedTotal,
    this.actualMinutesWorked,
    this.actualHoursWorked,
    this.actualPayout,
    this.platformFee,
    this.totalCharged,
    this.refundAmount,
    this.paymentMethod,
    this.paymentStatus,
    this.clockInTime,
    this.clockOutTime,
  });

  factory BookingDetailsPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsPaymentDtoToJson(this);
}

String? _parseStringFromMap(dynamic value) {
  if (value is String) {
    return value;
  }
  return null;
}

/// Parses an int that might come as a String from the API
int? _parseIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

/// Parses a double that might come as a String or int from the API
double? _parseDoubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
