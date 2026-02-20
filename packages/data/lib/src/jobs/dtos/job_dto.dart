import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';
import '../../profile_details/dtos/child_dto.dart';
import 'package:flutter/foundation.dart';

part 'job_dto.freezed.dart';
part 'job_dto.g.dart';

// Helper to handle zipCode being int or String
String _toString(dynamic value) => value.toString();

// Helper to handle parentUserId being String or Map
String? _parentIdFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map<String, dynamic>) {
    return value['_id'] as String? ?? value['id'] as String?;
  }
  return value.toString();
}

// Helper to clean address fields if they contain GeoJSON garbage
String _cleanAddressField(dynamic value) {
  if (value is String) {
    // Check if it looks like the GeoJSON garbage seen in logs
    if (value.trim().startsWith('{') || value.contains('type: Point')) {
      return '';
    }
    return value;
  }
  return '';
}

@freezed
abstract class JobAddressDto with _$JobAddressDto {
  const factory JobAddressDto({
    required String streetAddress,
    String? aptUnit,
    @JsonKey(fromJson: _cleanAddressField) required String city,
    @JsonKey(fromJson: _cleanAddressField) required String state,
    @JsonKey(fromJson: _toString) required String zipCode,
    double? latitude,
    double? longitude,
  }) = _JobAddressDto;

  factory JobAddressDto.fromJson(Map<String, dynamic> json) =>
      _$JobAddressDtoFromJson(json);

  const JobAddressDto._();

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
abstract class JobLocationDto with _$JobLocationDto {
  const factory JobLocationDto({
    required double latitude,
    required double longitude,
  }) = _JobLocationDto;

  factory JobLocationDto.fromJson(Map<String, dynamic> json) =>
      _$JobLocationDtoFromJson(json);

  const JobLocationDto._();

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
abstract class JobDto with _$JobDto {
  const factory JobDto({
    String? id,
    @JsonKey(fromJson: _parentIdFromJson) String? parentUserId,
    @Default([]) List<String> childIds,
    @Default([]) List<ChildDto> children,
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

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

  const JobDto._();

  factory JobDto.fromDomain(Job job) => JobDto(
        id: job.id,
        parentUserId: job.parentUserId,
        childIds: job.childIds,
        children: [], // Typically not mapped back to DTO for saving jobs
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

  Job toDomain() {
    debugPrint('DEBUG: JobDto.toDomain() for job: $id');
    debugPrint('DEBUG:   childIds: $childIds (length: ${childIds.length})');
    debugPrint('DEBUG:   children count: ${children.length}');
    debugPrint('DEBUG:   address: $address');
    if (address != null) {
      debugPrint('DEBUG:   address.city: ${address!.city}');
      debugPrint('DEBUG:   address.state: ${address!.state}');
      debugPrint('DEBUG:   address.zipCode: ${address!.zipCode}');
    } else {
      debugPrint('DEBUG:   address is NULL - will use empty defaults');
    }

    return Job(
        id: id,
        parentUserId: parentUserId,
        childIds: childIds,
        children: children.map((e) => e.toDomain()).toList(),
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
}
