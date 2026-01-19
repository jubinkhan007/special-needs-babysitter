// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobAddressDtoImpl _$$JobAddressDtoImplFromJson(Map<String, dynamic> json) =>
    _$JobAddressDtoImpl(
      streetAddress: json['streetAddress'] as String,
      aptUnit: json['aptUnit'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: _toString(json['zipCode']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$JobAddressDtoImplToJson(_$JobAddressDtoImpl instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'aptUnit': instance.aptUnit,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$JobLocationDtoImpl _$$JobLocationDtoImplFromJson(Map<String, dynamic> json) =>
    _$JobLocationDtoImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$JobLocationDtoImplToJson(
        _$JobLocationDtoImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$JobDtoImpl _$$JobDtoImplFromJson(Map<String, dynamic> json) => _$JobDtoImpl(
      id: json['id'] as String?,
      childIds: (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      title: json['title'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      address: JobAddressDto.fromJson(json['address'] as Map<String, dynamic>),
      location: const GeoJsonConverter()
          .fromJson(json['location'] as Map<String, dynamic>?),
      additionalDetails: json['additionalDetails'] as String?,
      payRate: (json['payRate'] as num?)?.toDouble(),
      saveAsDraft: json['saveAsDraft'] as bool? ?? false,
    );

Map<String, dynamic> _$$JobDtoImplToJson(_$JobDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childIds': instance.childIds,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'address': instance.address,
      'location': const GeoJsonConverter().toJson(instance.location),
      'additionalDetails': instance.additionalDetails,
      'payRate': instance.payRate,
      'saveAsDraft': instance.saveAsDraft,
    };
