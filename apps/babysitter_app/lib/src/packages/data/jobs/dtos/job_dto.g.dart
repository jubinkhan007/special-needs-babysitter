// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobAddressDto _$JobAddressDtoFromJson(Map<String, dynamic> json) =>
    _JobAddressDto(
      streetAddress: json['streetAddress'] as String,
      aptUnit: json['aptUnit'] as String?,
      city: _cleanAddressField(json['city']),
      state: _cleanAddressField(json['state']),
      zipCode: _toString(json['zipCode']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$JobAddressDtoToJson(_JobAddressDto instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'aptUnit': instance.aptUnit,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_JobLocationDto _$JobLocationDtoFromJson(Map<String, dynamic> json) =>
    _JobLocationDto(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$JobLocationDtoToJson(_JobLocationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_JobDto _$JobDtoFromJson(Map<String, dynamic> json) => _JobDto(
  id: json['id'] as String?,
  parentUserId: _parentIdFromJson(json['parentUserId']),
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ChildDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  title: json['title'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  timezone: json['timezone'] as String?,
  address: json['address'] == null
      ? null
      : JobAddressDto.fromJson(json['address'] as Map<String, dynamic>),
  location: const GeoJsonConverter().fromJson(json['location']),
  additionalDetails: json['additionalDetails'] as String?,
  payRate: (json['payRate'] as num?)?.toDouble(),
  saveAsDraft: json['saveAsDraft'] as bool? ?? false,
  status: json['status'] as String?,
  estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
  estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble(),
  applicantIds:
      (json['applicantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  acceptedSitterId: json['acceptedSitterId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  postedAt: json['postedAt'] == null
      ? null
      : DateTime.parse(json['postedAt'] as String),
);

Map<String, dynamic> _$JobDtoToJson(_JobDto instance) => <String, dynamic>{
  'id': instance.id,
  'parentUserId': instance.parentUserId,
  'childIds': instance.childIds,
  'children': instance.children,
  'title': instance.title,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'timezone': instance.timezone,
  'address': instance.address,
  'location': const GeoJsonConverter().toJson(instance.location),
  'additionalDetails': instance.additionalDetails,
  'payRate': instance.payRate,
  'saveAsDraft': instance.saveAsDraft,
  'status': instance.status,
  'estimatedDuration': instance.estimatedDuration,
  'estimatedTotal': instance.estimatedTotal,
  'applicantIds': instance.applicantIds,
  'acceptedSitterId': instance.acceptedSitterId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'postedAt': instance.postedAt?.toIso8601String(),
};
