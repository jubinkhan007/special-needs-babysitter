import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'job_dto.freezed.dart';
part 'job_dto.g.dart';

// Helper to handle zipCode being int or String
String _toString(dynamic value) => value.toString();

@freezed
class JobAddressDto with _$JobAddressDto {
  const factory JobAddressDto({
    required String streetAddress,
    String? aptUnit,
    required String city,
    required String state,
    @JsonKey(fromJson: _toString) required String zipCode,
    double? latitude,
    double? longitude,
  }) = _JobAddressDto;

  const JobAddressDto._();

  factory JobAddressDto.fromJson(Map<String, dynamic> json) =>
      _$JobAddressDtoFromJson(json);

  factory JobAddressDto.fromDomain(JobAddress address) => JobAddressDto(
        streetAddress: address.streetAddress,
        aptUnit: address.aptUnit,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        latitude: address.latitude,
        longitude: address.longitude,
      );

  JobAddress toDomain() => JobAddress(
        streetAddress: streetAddress,
        aptUnit: aptUnit,
        city: city,
        state: state,
        zipCode: zipCode,
        latitude: latitude,
        longitude: longitude,
      );
}

@freezed
class JobLocationDto with _$JobLocationDto {
  const factory JobLocationDto({
    required double latitude,
    required double longitude,
  }) = _JobLocationDto;

  const JobLocationDto._();

  factory JobLocationDto.fromJson(Map<String, dynamic> json) =>
      _$JobLocationDtoFromJson(json);

  factory JobLocationDto.fromDomain(JobLocation location) => JobLocationDto(
        latitude: location.latitude,
        longitude: location.longitude,
      );

  JobLocation toDomain() => JobLocation(
        latitude: latitude,
        longitude: longitude,
      );
}

class GeoJsonConverter implements JsonConverter<JobLocationDto?, dynamic> {
  const GeoJsonConverter();

  @override
  JobLocationDto? fromJson(dynamic json) {
    if (json == null) return null;

    // If it comes as a string, try to decode it (if it's a JSON string) or ignore
    if (json is String) {
      // Optional: try to decode if we suspect it's a JSON string.
      // For now, if it's a string not matching expectations, return null.
      return null;
    }

    if (json is! Map<String, dynamic>) return null;

    // Handle GeoJSON format: { "type": "Point", "coordinates": [long, lat] }
    if (json['type'] == 'Point' && json['coordinates'] is List) {
      final coords = json['coordinates'] as List;
      if (coords.length >= 2) {
        return JobLocationDto(
          latitude: (coords[1] as num).toDouble(),
          longitude: (coords[0] as num).toDouble(),
        );
      }
    }
    // Fallback to standard
    try {
      return JobLocationDto.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  dynamic toJson(JobLocationDto? object) {
    if (object == null) return null;
    return object.toJson();
  }
}

@freezed
class JobDto with _$JobDto {
  const factory JobDto({
    String? id,
    String? parentUserId,
    @Default([]) List<String> childIds,
    String? title,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? timezone,
    JobAddressDto? address,
    @GeoJsonConverter() JobLocationDto? location,
    String? additionalDetails,
    double? payRate,
    @Default(false) bool saveAsDraft,
    String? status,
    int? estimatedDuration,
    double? estimatedTotal,
    @Default([]) List<String> applicantIds,
    String? acceptedSitterId,
    DateTime? createdAt,
    DateTime? postedAt,
  }) = _JobDto;

  const JobDto._();

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

  factory JobDto.fromDomain(Job job) => JobDto(
        id: job.id,
        parentUserId: job.parentUserId,
        childIds: job.childIds,
        title: job.title,
        startDate: job.startDate,
        endDate: job.endDate,
        startTime: job.startTime,
        endTime: job.endTime,
        timezone: job.timezone,
        address: JobAddressDto.fromDomain(job.address),
        location: job.location != null
            ? JobLocationDto.fromDomain(job.location!)
            : null,
        additionalDetails: job.additionalDetails,
        payRate: job.payRate,
        saveAsDraft: job.saveAsDraft,
        status: job.status,
        estimatedDuration: job.estimatedDuration,
        estimatedTotal: job.estimatedTotal,
        applicantIds: job.applicantIds,
        acceptedSitterId: job.acceptedSitterId,
        createdAt: job.createdAt,
        postedAt: job.postedAt,
      );

  Job toDomain() => Job(
        id: id,
        parentUserId: parentUserId,
        childIds: childIds,
        title: title ?? '',
        startDate: startDate ?? '',
        endDate: endDate ?? '',
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        timezone: timezone,
        address: address?.toDomain() ??
            const JobAddress(
              streetAddress: '',
              city: '',
              state: '',
              zipCode: '',
            ),
        location: location?.toDomain(),
        additionalDetails: additionalDetails ?? '',
        payRate: payRate ?? 0.0,
        saveAsDraft: saveAsDraft,
        status: status,
        estimatedDuration: estimatedDuration,
        estimatedTotal: estimatedTotal,
        applicantIds: applicantIds,
        acceptedSitterId: acceptedSitterId,
        createdAt: createdAt,
        postedAt: postedAt,
      );
}
