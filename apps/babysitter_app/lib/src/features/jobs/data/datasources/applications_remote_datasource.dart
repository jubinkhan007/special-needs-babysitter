import 'package:dio/dio.dart';
import '../models/application_dto.dart';
import '../models/application_detail_dto.dart';

/// Remote data source for fetching job applications.
class ApplicationsRemoteDataSource {
  final Dio _dio;

  ApplicationsRemoteDataSource(this._dio);

  /// Fetches applications for a specific job.
  Future<List<ApplicationDto>> getApplications(String jobId) async {
    print('DEBUG: ApplicationsRemoteDataSource.getApplications called');
    print('DEBUG: jobId = "$jobId"');
    print('DEBUG: baseUrl = ${_dio.options.baseUrl}');
    print('DEBUG: Full URL = ${_dio.options.baseUrl}/jobs/$jobId/applications');

    try {
      final response = await _dio.get('/jobs/$jobId/applications');
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      final responseDto = ApplicationsResponseDto.fromJson(response.data);
      print(
          'DEBUG: Parsed ${responseDto.data.applications.length} applications');
      return responseDto.data.applications;
    } catch (e) {
      print('DEBUG: ApplicationsRemoteDataSource error: $e');
      rethrow;
    }
  }

  /// Fetches application detail by ID.
  Future<ApplicationDetailDto> getApplicationDetail({
    required String jobId,
    required String applicationId,
  }) async {
    print(
        'DEBUG: getApplicationDetail called with jobId: $jobId, applicationId: $applicationId');

    try {
      final response =
          await _dio.get('/jobs/$jobId/applications/$applicationId');
      print('DEBUG: getApplicationDetail response: ${response.data}');

      final responseDto = ApplicationDetailResponseDto.fromJson(response.data);
      return responseDto.data;
    } catch (e) {
      print('DEBUG: getApplicationDetail error: $e');
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
    print('DEBUG: respondToApplication called');
    print('DEBUG: jobId=$jobId, applicationId=$applicationId, action=$action');

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
      print('DEBUG: respondToApplication response: ${response.data}');
    } catch (e) {
      print('DEBUG: respondToApplication error: $e');
      rethrow;
    }
  }
}
