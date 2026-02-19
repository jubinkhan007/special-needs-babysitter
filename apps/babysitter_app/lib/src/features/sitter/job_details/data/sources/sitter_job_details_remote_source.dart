import 'package:dio/dio.dart';

import '../dtos/job_details_response_dto.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for fetching job details from API.
class SitterJobDetailsRemoteSource {
  final Dio _dio;

  SitterJobDetailsRemoteSource(this._dio);

  /// Fetch job details by ID from the API.
  Future<JobDetailsResponseDto> getJobDetails(String jobId) async {
    debugPrint(
        'DEBUG: SitterJobDetailsRemoteSource.getJobDetails called with jobId=$jobId');
    debugPrint('DEBUG: Making GET request to /jobs/$jobId');

    try {
      final response = await _dio.get('/jobs/$jobId');
      debugPrint('DEBUG: Response status: ${response.statusCode}');
      debugPrint('DEBUG: Response data: ${response.data}');

      final dto =
          JobDetailsResponseDto.fromJson(response.data as Map<String, dynamic>);
      debugPrint('DEBUG: Parsed DTO successfully, job title: ${dto.data.job.title}');

      return dto;
    } catch (e, stack) {
      debugPrint('DEBUG: Error fetching job details: $e');
      debugPrint('DEBUG: Stack trace: $stack');
      rethrow;
    }
  }
}
