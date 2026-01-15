// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitterDto _$SitterDtoFromJson(Map<String, dynamic> json) => SitterDto(
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

Map<String, dynamic> _$SitterDtoToJson(SitterDto instance) => <String, dynamic>{
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

ApplicationDto _$ApplicationDtoFromJson(Map<String, dynamic> json) =>
    ApplicationDto(
      id: json['id'] as String,
      status: json['status'] as String,
      isInvitation: json['isInvitation'] as bool,
      coverLetter: json['coverLetter'] as String?,
      sitter: SitterDto.fromJson(json['sitter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationDtoToJson(ApplicationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'isInvitation': instance.isInvitation,
      'coverLetter': instance.coverLetter,
      'sitter': instance.sitter,
    };

ApplicationsDataDto _$ApplicationsDataDtoFromJson(Map<String, dynamic> json) =>
    ApplicationsDataDto(
      applications: (json['applications'] as List<dynamic>)
          .map((e) => ApplicationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ApplicationsDataDtoToJson(
        ApplicationsDataDto instance) =>
    <String, dynamic>{
      'applications': instance.applications,
      'total': instance.total,
    };

ApplicationsResponseDto _$ApplicationsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationsResponseDto(
      success: json['success'] as bool,
      data: ApplicationsDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationsResponseDtoToJson(
        ApplicationsResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
