import 'package:dio/dio.dart';

import '../dtos/job_details_response_dto.dart';

/// Remote data source for fetching job details from API.
class SitterJobDetailsRemoteSource {
  final Dio _dio;

  SitterJobDetailsRemoteSource(this._dio);

  /// Fetch job details by ID from the API.
  Future<JobDetailsResponseDto> getJobDetails(String jobId) async {
    print(
        'DEBUG: SitterJobDetailsRemoteSource.getJobDetails called with jobId=$jobId');
    print('DEBUG: Making GET request to /jobs/$jobId');

    try {
      final response = await _dio.get('/jobs/$jobId');
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      final dto =
          JobDetailsResponseDto.fromJson(response.data as Map<String, dynamic>);
      print('DEBUG: Parsed DTO successfully, job title: ${dto.data.job.title}');

      return dto;
    } catch (e, stack) {
      print('DEBUG: Error fetching job details: $e');
      print('DEBUG: Stack trace: $stack');
      rethrow;
    }
  }
}
