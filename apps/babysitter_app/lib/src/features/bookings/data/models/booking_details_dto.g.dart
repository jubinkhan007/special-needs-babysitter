// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDetailsResponseDto _$BookingDetailsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsResponseDto(
      success: json['success'] as bool,
      data: BookingDetailsDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingDetailsResponseDtoToJson(
        BookingDetailsResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

BookingDetailsDto _$BookingDetailsDtoFromJson(Map<String, dynamic> json) =>
    BookingDetailsDto(
      id: json['id'] as String,
      status: json['status'] as String,
      applicationType: json['applicationType'] as String?,
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      isPaused: json['isPaused'] as bool?,
      sitter: json['sitter'] == null
          ? null
          : BookingDetailsSitterDto.fromJson(
              json['sitter'] as Map<String, dynamic>),
      job: json['job'] == null
          ? null
          : BookingDetailsJobDto.fromJson(json['job'] as Map<String, dynamic>),
      jobId: json['jobId'] as String?,
      family: json['family'] == null
          ? null
          : BookingDetailsFamilyDto.fromJson(
              json['family'] as Map<String, dynamic>),
      payment: json['payment'] == null
          ? null
          : BookingDetailsPaymentDto.fromJson(
              json['payment'] as Map<String, dynamic>),
      routeCoordinates: json['routeCoordinates'] as List<dynamic>?,
    );

Map<String, dynamic> _$BookingDetailsDtoToJson(BookingDetailsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'applicationType': instance.applicationType,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'isPaused': instance.isPaused,
      'sitter': instance.sitter,
      'job': instance.job,
      'jobId': instance.jobId,
      'family': instance.family,
      'payment': instance.payment,
      'routeCoordinates': instance.routeCoordinates,
    };

BookingDetailsSitterDto _$BookingDetailsSitterDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsSitterDto(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      reliabilityScore: _parseIntFromJson(json['reliabilityScore']),
      responseRate: _parseIntFromJson(json['responseRate']),
      yearsOfExperience: json['yearsOfExperience'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      distance: json['distance'] as String?,
      currentLocation: _parseStringFromMap(json['currentLocation']),
    );

Map<String, dynamic> _$BookingDetailsSitterDtoToJson(
        BookingDetailsSitterDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
      'reliabilityScore': instance.reliabilityScore,
      'responseRate': instance.responseRate,
      'yearsOfExperience': instance.yearsOfExperience,
      'skills': instance.skills,
      'distance': instance.distance,
      'currentLocation': instance.currentLocation,
    };

BookingDetailsJobDto _$BookingDetailsJobDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsJobDto(
      id: json['id'] as String,
      title: json['title'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      payRate: _parseDoubleFromJson(json['payRate']),
      numberOfDays: _parseIntFromJson(json['numberOfDays']),
      additionalDetails: json['additionalDetails'] as String?,
      fullAddress: json['fullAddress'] as String?,
      location: _parseStringFromMap(json['location']),
      coordinates: json['coordinates'] == null
          ? null
          : BookingDetailsCoordinatesDto.fromJson(
              json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingDetailsJobDtoToJson(
        BookingDetailsJobDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'payRate': instance.payRate,
      'numberOfDays': instance.numberOfDays,
      'additionalDetails': instance.additionalDetails,
      'fullAddress': instance.fullAddress,
      'location': instance.location,
      'coordinates': instance.coordinates,
    };

BookingDetailsCoordinatesDto _$BookingDetailsCoordinatesDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsCoordinatesDto(
      latitude: _parseDoubleFromJson(json['latitude']),
      longitude: _parseDoubleFromJson(json['longitude']),
    );

Map<String, dynamic> _$BookingDetailsCoordinatesDtoToJson(
        BookingDetailsCoordinatesDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

BookingDetailsFamilyDto _$BookingDetailsFamilyDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsFamilyDto(
      familyName: json['familyName'] as String?,
      childrenCount: _parseIntFromJson(json['childrenCount']),
    );

Map<String, dynamic> _$BookingDetailsFamilyDtoToJson(
        BookingDetailsFamilyDto instance) =>
    <String, dynamic>{
      'familyName': instance.familyName,
      'childrenCount': instance.childrenCount,
    };

BookingDetailsPaymentDto _$BookingDetailsPaymentDtoFromJson(
        Map<String, dynamic> json) =>
    BookingDetailsPaymentDto(
      hourlyRate: _parseDoubleFromJson(json['hourlyRate']),
      estimatedHours: _parseDoubleFromJson(json['estimatedHours']),
      estimatedTotal: _parseDoubleFromJson(json['estimatedTotal']),
      actualMinutesWorked: _parseIntFromJson(json['actualMinutesWorked']),
      actualHoursWorked: _parseDoubleFromJson(json['actualHoursWorked']),
      actualPayout: _parseDoubleFromJson(json['actualPayout']),
      platformFee: _parseDoubleFromJson(json['platformFee']),
      totalCharged: _parseDoubleFromJson(json['totalCharged']),
      refundAmount: _parseDoubleFromJson(json['refundAmount']),
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
    );

Map<String, dynamic> _$BookingDetailsPaymentDtoToJson(
        BookingDetailsPaymentDto instance) =>
    <String, dynamic>{
      'hourlyRate': instance.hourlyRate,
      'estimatedHours': instance.estimatedHours,
      'estimatedTotal': instance.estimatedTotal,
      'actualMinutesWorked': instance.actualMinutesWorked,
      'actualHoursWorked': instance.actualHoursWorked,
      'actualPayout': instance.actualPayout,
      'platformFee': instance.platformFee,
      'totalCharged': instance.totalCharged,
      'refundAmount': instance.refundAmount,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
    };
