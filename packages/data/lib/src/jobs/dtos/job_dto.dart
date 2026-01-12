import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'job_dto.freezed.dart';
part 'job_dto.g.dart';

@freezed
class JobAddressDto with _$JobAddressDto {
  const factory JobAddressDto({
    required String streetAddress,
    String? aptUnit,
    required String city,
    required String state,
    required String zipCode,
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

@freezed
class JobDto with _$JobDto {
  const factory JobDto({
    String? id,
    required List<String> childIds,
    required String title,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required JobAddressDto address,
    JobLocationDto? location,
    required String additionalDetails,
    required double payRate,
    @Default(false) bool saveAsDraft,
  }) = _JobDto;

  const JobDto._();

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

  factory JobDto.fromDomain(Job job) => JobDto(
        id: job.id,
        childIds: job.childIds,
        title: job.title,
        startDate: job.startDate,
        endDate: job.endDate,
        startTime: job.startTime,
        endTime: job.endTime,
        address: JobAddressDto.fromDomain(job.address),
        location: job.location != null
            ? JobLocationDto.fromDomain(job.location!)
            : null,
        additionalDetails: job.additionalDetails,
        payRate: job.payRate,
        saveAsDraft: job.saveAsDraft,
      );

  Job toDomain() => Job(
        id: id,
        childIds: childIds,
        title: title,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        address: address.toDomain(),
        location: location?.toDomain(),
        additionalDetails: additionalDetails,
        payRate: payRate,
        saveAsDraft: saveAsDraft,
      );
}
