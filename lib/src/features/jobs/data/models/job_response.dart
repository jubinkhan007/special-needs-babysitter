import 'package:json_annotation/json_annotation.dart';
import 'job_dto.dart';

part 'job_response.g.dart';

@JsonSerializable()
class JobResponse {
  final bool success;
  final JobData data;

  JobResponse({required this.success, required this.data});

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}

@JsonSerializable()
class JobData {
  final List<JobDto> jobs;
  final int total;
  final int limit;
  final int offset;

  JobData({
    required this.jobs,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory JobData.fromJson(Map<String, dynamic> json) =>
      _$JobDataFromJson(json);
  Map<String, dynamic> toJson() => _$JobDataToJson(this);
}
