import 'package:dio/dio.dart';
import '../models/application_dto.dart';
import '../models/application_detail_dto.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for fetching job applications.
class ApplicationsRemoteDataSource {
  final Dio _dio;

  ApplicationsRemoteDataSource(this._dio);

  /// Fetches applications for a specific job.
  Future<List<ApplicationDto>> getApplications(String jobId) async {
    debugPrint('DEBUG: ApplicationsRemoteDataSource.getApplications called');
    debugPrint('DEBUG: jobId = "$jobId"');
    debugPrint('DEBUG: baseUrl = ${_dio.options.baseUrl}');
    debugPrint('DEBUG: Full URL = ${_dio.options.baseUrl}/jobs/$jobId/applications');

    try {
      final response = await _dio.get('/jobs/$jobId/applications');
      debugPrint('DEBUG: Response status: ${response.statusCode}');
      debugPrint('DEBUG: Response data: ${response.data}');

      final responseDto = ApplicationsResponseDto.fromJson(response.data);
      debugPrint(
          'DEBUG: Parsed ${responseDto.data.applications.length} applications');
      return responseDto.data.applications;
    } catch (e) {
      debugPrint('DEBUG: ApplicationsRemoteDataSource error: $e');
      rethrow;
    }
  }

  /// Fetches application detail by ID.
  Future<ApplicationDetailDto> getApplicationDetail({
    required String jobId,
    required String applicationId,
  }) async {
    debugPrint(
        'DEBUG: getApplicationDetail called with jobId: $jobId, applicationId: $applicationId');

    try {
      final response =
          await _dio.get('/jobs/$jobId/applications/$applicationId');
      debugPrint('DEBUG: getApplicationDetail response: ${response.data}');

      final responseDto = ApplicationDetailResponseDto.fromJson(response.data);
      return responseDto.data;
    } catch (e) {
      debugPrint('DEBUG: getApplicationDetail error: $e');
      rethrow;
    }
  }

  /// Responds to an application (accept or decline).
  /// [action] can be "accept" or "decline"
  /// [declineReason] is required when action is "decline"
  Future<void> respondToApplication({
    required String jobId,
    required String applicationId,
    required String action,
    String? declineReason,
  }) async {
    debugPrint('DEBUG: respondToApplication called');
    debugPrint('DEBUG: jobId=$jobId, applicationId=$applicationId, action=$action');

    final body = <String, dynamic>{
      'action': action,
    };

    if (action == 'decline' && declineReason != null) {
      body['declineReason'] = declineReason;
    }

    try {
      final response = await _dio.post(
        '/jobs/$jobId/applications/$applicationId/respond',
        data: body,
      );
      debugPrint('DEBUG: respondToApplication response: ${response.data}');
    } catch (e) {
      debugPrint('DEBUG: respondToApplication error: $e');
      rethrow;
    }
  }
}
