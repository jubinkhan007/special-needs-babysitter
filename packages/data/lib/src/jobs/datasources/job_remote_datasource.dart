import 'package:dio/dio.dart';
import '../dtos/job_dto.dart';

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
            'Job API Error: ${e.response?.data['message'] ?? e.response?.data.toString() ?? e.message}');
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

      print('DEBUG: JobRemoteDataSource.getJobs called with status=$status');
      final response = await _dio.get(
        '/jobs',
        queryParameters: queryParams,
      );
      print(
          'DEBUG: JobRemoteDataSource.getJobs response status: ${response.statusCode}');
      if (response.data['success'] == true) {
        final List<dynamic> jobsJson = response.data['data']['jobs'];
        return jobsJson
            .map((json) => JobDto.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('DEBUG: JobRemoteDataSource failed: ${response.data}');
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

      final response = await _dio.put(
        '/jobs/$id',
        data: jobDto.toJson(),
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

      print(
          'DEBUG: JobRemoteDataSource.inviteSitter response: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ??
            response.data['error'] ??
            'Failed to invite sitter');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(
            'Invite API Error: ${e.response?.data['message'] ?? e.response?.data['error'] ?? e.message}');
      }
      rethrow;
    }
  }
}
