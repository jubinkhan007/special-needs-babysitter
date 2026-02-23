import 'package:json_annotation/json_annotation.dart';

part 'job_dto.g.dart';

// Helper to handle zipCode/numbers as String
String _toString(dynamic value) => value.toString();

@JsonSerializable()
class JobDto {
  final String id;
  final String parentUserId;
  @JsonKey(defaultValue: [])
  final List<String> childIds;
  final String title;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final AddressDto? address;
  final LocationDto? location;
  final String? additionalDetails;
  final double payRate;
  final String status;
  final int estimatedDuration;
  final double estimatedTotal;
  @JsonKey(defaultValue: [])
  final List<String> applicantIds;
  final String? acceptedSitterId;
  final String createdAt;
  final String updatedAt;
  final String? postedAt; // Made nullable as it might be missing
  final String? cancelledAt;

  JobDto({
    required this.id,
    required this.parentUserId,
    required this.childIds,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.address,
    this.location,
    this.additionalDetails,
    required this.payRate,
    required this.status,
    required this.estimatedDuration,
    required this.estimatedTotal,
    required this.applicantIds,
    this.acceptedSitterId,
    required this.createdAt,
    required this.updatedAt,
    this.postedAt,
    this.cancelledAt,
  });

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JobDtoToJson(this);
}

@JsonSerializable()
class AddressDto {
  final String streetAddress;
  final String? aptUnit;
  final String city;
  final String state;
  @JsonKey(fromJson: _toString)
  final String zipCode;
  final double latitude;
  final double longitude;
  final String publicLocation;

  AddressDto({
    required this.streetAddress,
    this.aptUnit,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.publicLocation,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);
}

@JsonSerializable()
class LocationDto {
  final String type;
  final List<double> coordinates;

  LocationDto({
    required this.type,
    required this.coordinates,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}
