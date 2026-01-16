// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentBookingsResponseDto _$ParentBookingsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ParentBookingsResponseDto(
      bookings: (json['bookings'] as List<dynamic>)
          .map((e) => ParentBookingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
    );

Map<String, dynamic> _$ParentBookingsResponseDtoToJson(
        ParentBookingsResponseDto instance) =>
    <String, dynamic>{
      'bookings': instance.bookings,
      'total': instance.total,
    };

ParentBookingDto _$ParentBookingDtoFromJson(Map<String, dynamic> json) =>
    ParentBookingDto(
      id: json['id'] as String,
      status: json['status'] as String,
      isInvitation: json['isInvitation'] as bool?,
      applicationType: json['applicationType'] as String?,
      coverLetter: json['coverLetter'] as String?,
      createdAt: json['createdAt'] as String?,
      acceptedAt: json['acceptedAt'] as String?,
      declinedAt: json['declinedAt'] as String?,
      sitter: json['sitter'] == null
          ? null
          : ParentBookingSitterDto.fromJson(
              json['sitter'] as Map<String, dynamic>),
      job: json['job'] == null
          ? null
          : ParentBookingJobDto.fromJson(json['job'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParentBookingDtoToJson(ParentBookingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'isInvitation': instance.isInvitation,
      'applicationType': instance.applicationType,
      'coverLetter': instance.coverLetter,
      'createdAt': instance.createdAt,
      'acceptedAt': instance.acceptedAt,
      'declinedAt': instance.declinedAt,
      'sitter': instance.sitter,
      'job': instance.job,
    };

ParentBookingSitterDto _$ParentBookingSitterDtoFromJson(
        Map<String, dynamic> json) =>
    ParentBookingSitterDto(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      reliabilityScore: json['reliabilityScore'] as int?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ParentBookingSitterDtoToJson(
        ParentBookingSitterDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'hourlyRate': instance.hourlyRate,
      'reliabilityScore': instance.reliabilityScore,
      'skills': instance.skills,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ParentBookingJobDto _$ParentBookingJobDtoFromJson(Map<String, dynamic> json) =>
    ParentBookingJobDto(
      id: json['id'] as String,
      title: json['title'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      payRate: (json['payRate'] as num?)?.toDouble(),
      status: json['status'] as String?,
      location: json['location'] as String?,
      fullAddress: json['fullAddress'] as String?,
      childrenCount: json['childrenCount'] as int?,
      additionalDetails: json['additionalDetails'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map(
              (e) => ParentBookingChildDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParentBookingJobDtoToJson(
        ParentBookingJobDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'payRate': instance.payRate,
      'status': instance.status,
      'location': instance.location,
      'fullAddress': instance.fullAddress,
      'childrenCount': instance.childrenCount,
      'additionalDetails': instance.additionalDetails,
      'children': instance.children,
    };

ParentBookingChildDto _$ParentBookingChildDtoFromJson(
        Map<String, dynamic> json) =>
    ParentBookingChildDto(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: json['age'] as int?,
      specialNeedsDiagnosis: json['specialNeedsDiagnosis'] as String?,
    );

Map<String, dynamic> _$ParentBookingChildDtoToJson(
        ParentBookingChildDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'specialNeedsDiagnosis': instance.specialNeedsDiagnosis,
    };
