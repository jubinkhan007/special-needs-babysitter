import 'package:dio/dio.dart';
import '../../domain/job.dart';
import '../../domain/jobs_repository.dart';
import '../../domain/job_details.dart';
import '../mappers/job_mapper.dart';
import '../models/job_dto.dart';
import '../models/job_response.dart';

class JobsRepositoryImpl implements JobsRepository {
  final Dio _client;

  JobsRepositoryImpl(this._client);

  @override
  Future<void> updateJob(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        '/jobs/$id',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success
        return;
      } else {
        throw Exception('Failed to update job: Status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteJob(String id) async {
    try {
      final response = await _client.delete('/jobs/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to delete job: Status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JobDetails> getJobDetails(String id) async {
    try {
      final response = await _client.get('/jobs/$id');

      if (response.statusCode == 200 && response.data != null) {
        final map = response.data;

        try {
          // If map has 'data' key and it's a map, use that.
          if (map is Map<String, dynamic> && map.containsKey('data')) {
            final dataParams = map['data'] as Map<String, dynamic>;
            // Check if 'job' key exists inside 'data' (based on logs)
            if (dataParams.containsKey('job')) {
              // The API returns { data: { job: { ... }, children: [...] } }
              final jobMap = dataParams['job'] as Map<String, dynamic>;
              final dto = JobDto.fromJson(jobMap);
              return dto.toJobDetails();
            } else {
              // Fallback: maybe 'data' IS the job directly (unlikely based on logs but possible for other endpoints)
              final dto = JobDto.fromJson(dataParams);
              return dto.toJobDetails();
            }
          } else {
            // Maybe direct?
            final dto = JobDto.fromJson(map);
            return dto.toJobDetails();
          }
        } catch (e) {
          rethrow;
        }
      } else {
        throw Exception('Failed to fetch job details: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Job>> getJobs() async {
    try {
      final response = await _client.get('/jobs', queryParameters: {
        'status': 'posted', // Default as per screenshot
        'limit': 20,
        'offset': 0,
      });

      if (response.statusCode == 200 && response.data != null) {
        print(
            'DEBUG: Jobs API Response: ${response.data}'); // Requested debug log
        final jobResponse = JobResponse.fromJson(response.data);
        if (jobResponse.success) {
          return jobResponse.data.jobs.map((dto) => dto.toDomain()).toList();
        } else {
          throw Exception('Failed to fetch jobs: API success=false');
        }
      } else {
        throw Exception('Failed to fetch jobs: Status ${response.statusCode}');
      }
    } catch (e) {
      // Allow error to propagate or handle/wrap it
      rethrow;
    }
  }
}
