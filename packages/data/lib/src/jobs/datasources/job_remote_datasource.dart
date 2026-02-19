import 'package:dio/dio.dart';
import '../dtos/job_dto.dart';
import 'package:flutter/foundation.dart';

class JobRemoteDataSource {
  final Dio _dio;

  JobRemoteDataSource(this._dio);

  Future<String> createJob(JobDto jobDto) async {
    try {
      final response = await _dio.post(
        '/jobs',
        data: jobDto.toJson(),
      );

      if (response.data['success'] == true) {
        return response.data['data']['jobId'] as String;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create job');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
            'Job API Error: ${e.response?.data['message'] ?? e.response?.data.toString() ?? e.message}',);
      }
      rethrow;
    }
  }

  Future<List<JobDto>> getJobs({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      debugPrint('DEBUG: JobRemoteDataSource.getJobs called with status=$status');
      final response = await _dio.get(
        '/jobs',
        queryParameters: queryParams,
      );
      debugPrint(
          'DEBUG: JobRemoteDataSource.getJobs response status: ${response.statusCode}',);
      if (response.data['success'] == true) {
        final List<dynamic> jobsJson = response.data['data']['jobs'];
        return jobsJson
            .map((json) => JobDto.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('DEBUG: JobRemoteDataSource failed: ${response.data}');
        throw Exception('Failed to fetch jobs');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<JobDto> getJobById(String id) async {
    try {
      final response = await _dio.get('/jobs/$id');
      if (response.data['success'] == true) {
        return JobDto.fromJson(response.data['data']['job']);
      } else {
        throw Exception('Failed to fetch job');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateJob(JobDto jobDto) async {
    try {
      final id = jobDto.id;
      if (id == null) throw Exception('Job ID is required for update');

      // For updating existing jobs, only send the editable fields
      // Don't send saveAsDraft or status as the API interprets these as "post" actions
      final updateData = <String, dynamic>{
        if (jobDto.childIds.isNotEmpty) 'childIds': jobDto.childIds,
        if (jobDto.title != null) 'title': jobDto.title,
        if (jobDto.startDate != null) 'startDate': jobDto.startDate,
        if (jobDto.endDate != null) 'endDate': jobDto.endDate,
        if (jobDto.startTime != null) 'startTime': jobDto.startTime,
        if (jobDto.endTime != null) 'endTime': jobDto.endTime,
        if (jobDto.timezone != null) 'timezone': jobDto.timezone,
        if (jobDto.address != null) 'address': jobDto.address!.toJson(),
        if (jobDto.location != null) 'location': jobDto.location!.toJson(),
        if (jobDto.additionalDetails != null) 'additionalDetails': jobDto.additionalDetails,
        if (jobDto.payRate != null) 'payRate': jobDto.payRate,
        // Intentionally NOT sending: saveAsDraft, status (these are for create/post operations)
      };

      debugPrint('DEBUG: Updating job $id with data: $updateData');

      final response = await _dio.put(
        '/jobs/$id',
        data: updateData,
      );
      if (response.data['success'] != true) {
        throw Exception('Failed to update job');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      final response = await _dio.delete('/jobs/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete job');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> inviteSitter(String jobId, String sitterId) async {
    try {
      final response = await _dio.post(
        '/jobs/$jobId/invite',
        data: {'sitterId': sitterId},
      );

      debugPrint(
          'DEBUG: JobRemoteDataSource.inviteSitter response: ${response.data}',);

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ??
            response.data['error'] ??
            'Failed to invite sitter',);
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(
            'Invite API Error: ${e.response?.data['message'] ?? e.response?.data['error'] ?? e.message}',);
      }
      rethrow;
    }
  }
}
