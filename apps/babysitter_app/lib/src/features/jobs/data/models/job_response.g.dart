// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobResponse _$JobResponseFromJson(Map<String, dynamic> json) => JobResponse(
      success: json['success'] as bool,
      data: JobData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobResponseToJson(JobResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

JobData _$JobDataFromJson(Map<String, dynamic> json) => JobData(
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => JobDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$JobDataToJson(JobData instance) => <String, dynamic>{
      'jobs': instance.jobs,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };
