// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildDto _$ChildDtoFromJson(Map<String, dynamic> json) => ChildDto(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num?)?.toInt(),
      specialNeedsDiagnosis: json['specialNeedsDiagnosis'] as String?,
      personalityDescription: json['personalityDescription'] as String?,
      medicationDietaryNeeds: json['medicationDietaryNeeds'] as String?,
      hasAllergies: json['hasAllergies'] as bool?,
      allergyTypes: (json['allergyTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasTriggers: json['hasTriggers'] as bool?,
      triggerTypes: (json['triggerTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      triggers: json['triggers'] as String?,
      calmingMethods: json['calmingMethods'] as String?,
      transportationModes: (json['transportationModes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      equipmentSafety: (json['equipmentSafety'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      needsDropoff: json['needsDropoff'] as bool?,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      transportSpecialInstructions:
          json['transportSpecialInstructions'] as String?,
    );

Map<String, dynamic> _$ChildDtoToJson(ChildDto instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'specialNeedsDiagnosis': instance.specialNeedsDiagnosis,
      'personalityDescription': instance.personalityDescription,
      'medicationDietaryNeeds': instance.medicationDietaryNeeds,
      'hasAllergies': instance.hasAllergies,
      'allergyTypes': instance.allergyTypes,
      'hasTriggers': instance.hasTriggers,
      'triggerTypes': instance.triggerTypes,
      'triggers': instance.triggers,
      'calmingMethods': instance.calmingMethods,
      'transportationModes': instance.transportationModes,
      'equipmentSafety': instance.equipmentSafety,
      'needsDropoff': instance.needsDropoff,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'transportSpecialInstructions': instance.transportSpecialInstructions,
    };

JobDetailDto _$JobDetailDtoFromJson(Map<String, dynamic> json) => JobDetailDto(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      payRate: (json['payRate'] as num?)?.toDouble(),
      status: json['status'] as String?,
      additionalDetails: json['additionalDetails'] as String?,
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble(),
      location: json['location'] as String?,
      fullAddress: json['fullAddress'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      familyName: json['familyName'] as String?,
      familyPhotoUrl: json['familyPhotoUrl'] as String?,
      childrenCount: (json['childrenCount'] as num?)?.toInt(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ChildDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$JobDetailDtoToJson(JobDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'payRate': instance.payRate,
      'status': instance.status,
      'additionalDetails': instance.additionalDetails,
      'estimatedDuration': instance.estimatedDuration,
      'estimatedTotal': instance.estimatedTotal,
      'location': instance.location,
      'fullAddress': instance.fullAddress,
      'distance': instance.distance,
      'familyName': instance.familyName,
      'familyPhotoUrl': instance.familyPhotoUrl,
      'childrenCount': instance.childrenCount,
      'children': instance.children,
      'requiredSkills': instance.requiredSkills,
    };

ApplicationSitterDto _$ApplicationSitterDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationSitterDto(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      yearsOfExperience: json['yearsOfExperience'] as String?,
      reliabilityScore: (json['reliabilityScore'] as num?)?.toInt(),
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ApplicationSitterDtoToJson(
        ApplicationSitterDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'hourlyRate': instance.hourlyRate,
      'yearsOfExperience': instance.yearsOfExperience,
      'reliabilityScore': instance.reliabilityScore,
      'skills': instance.skills,
    };

ApplicationDetailDto _$ApplicationDetailDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationDetailDto(
      id: json['id'] as String,
      status: json['status'] as String,
      isInvitation: json['isInvitation'] as bool,
      coverLetter: json['coverLetter'] as String?,
      declineReason: json['declineReason'] as String?,
      declineOtherReason: json['declineOtherReason'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      hasMoreShifts: json['hasMoreShifts'] as bool?,
      createdAt: json['createdAt'] as String?,
      invitedAt: json['invitedAt'] as String?,
      acceptedAt: json['acceptedAt'] as String?,
      declinedAt: json['declinedAt'] as String?,
      withdrawnAt: json['withdrawnAt'] as String?,
      completedAt: json['completedAt'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
      job: JobDetailDto.fromJson(json['job'] as Map<String, dynamic>),
      sitter: json['sitter'] == null
          ? null
          : ApplicationSitterDto.fromJson(
              json['sitter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationDetailDtoToJson(
        ApplicationDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'isInvitation': instance.isInvitation,
      'coverLetter': instance.coverLetter,
      'declineReason': instance.declineReason,
      'declineOtherReason': instance.declineOtherReason,
      'cancellationReason': instance.cancellationReason,
      'hasMoreShifts': instance.hasMoreShifts,
      'createdAt': instance.createdAt,
      'invitedAt': instance.invitedAt,
      'acceptedAt': instance.acceptedAt,
      'declinedAt': instance.declinedAt,
      'withdrawnAt': instance.withdrawnAt,
      'completedAt': instance.completedAt,
      'cancelledAt': instance.cancelledAt,
      'job': instance.job,
      'sitter': instance.sitter,
    };

ApplicationDetailResponseDto _$ApplicationDetailResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationDetailResponseDto(
      success: json['success'] as bool,
      data: ApplicationDetailDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationDetailResponseDtoToJson(
        ApplicationDetailResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
