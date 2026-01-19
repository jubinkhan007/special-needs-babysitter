// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDto _$JobDtoFromJson(Map<String, dynamic> json) => JobDto(
      id: json['id'] as String,
      parentUserId: json['parentUserId'] as String,
      childIds: (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      address: json['address'] == null
          ? null
          : AddressDto.fromJson(json['address'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : LocationDto.fromJson(json['location'] as Map<String, dynamic>),
      additionalDetails: json['additionalDetails'] as String?,
      payRate: (json['payRate'] as num).toDouble(),
      status: json['status'] as String,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      estimatedTotal: (json['estimatedTotal'] as num).toDouble(),
      applicantIds: (json['applicantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      acceptedSitterId: json['acceptedSitterId'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      postedAt: json['postedAt'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
    );

Map<String, dynamic> _$JobDtoToJson(JobDto instance) => <String, dynamic>{
      'id': instance.id,
      'parentUserId': instance.parentUserId,
      'childIds': instance.childIds,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'address': instance.address,
      'location': instance.location,
      'additionalDetails': instance.additionalDetails,
      'payRate': instance.payRate,
      'status': instance.status,
      'estimatedDuration': instance.estimatedDuration,
      'estimatedTotal': instance.estimatedTotal,
      'applicantIds': instance.applicantIds,
      'acceptedSitterId': instance.acceptedSitterId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'postedAt': instance.postedAt,
      'cancelledAt': instance.cancelledAt,
    };

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
      streetAddress: json['streetAddress'] as String,
      aptUnit: json['aptUnit'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: _toString(json['zipCode']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      publicLocation: json['publicLocation'] as String,
    );

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'aptUnit': instance.aptUnit,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'publicLocation': instance.publicLocation,
    };

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$LocationDtoToJson(LocationDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
