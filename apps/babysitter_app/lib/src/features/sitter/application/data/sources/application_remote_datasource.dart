import 'package:dio/dio.dart';

import '../dtos/submit_application_request_dto.dart';
import '../models/application_model.dart';

/// Remote data source for application API calls.
class ApplicationRemoteDataSource {
  final Dio _dio;

  ApplicationRemoteDataSource(this._dio);

  /// Submit a job application via POST /applications.
  Future<void> submitApplication({
    required String jobId,
    required String coverLetter,
  }) async {
    final requestDto = SubmitApplicationRequestDto(
      jobId: jobId,
      coverLetter: coverLetter,
    );

    try {
      await _dio.post(
        '/applications',
        data: requestDto.toJson(),
      );
    } catch (e) {
      if (e is DioException) {
        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Get applications list with optional filters.
  Future<List<ApplicationModel>> getApplications({
    String? status,
    String? type,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (status != null) queryParams['status'] = status;
    if (type != null) queryParams['type'] = type;

    try {
      print('DEBUG: Fetching applications with params: $queryParams');
      final response = await _dio.get(
        '/applications',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final applications = data['applications'] as List;

      return applications
          .map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Applications API Error - Status: ${e.response?.statusCode}');
        print('DEBUG: Applications API Error - Data: ${e.response?.data}');
        print('DEBUG: Applications API Error - Params: $queryParams');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Get a single application by ID via GET /applications/{id}.
  Future<ApplicationModel> getApplicationById(String applicationId) async {
    try {
      final response = await _dio.get('/applications/$applicationId');

      final data = response.data['data'] as Map<String, dynamic>;
      return ApplicationModel.fromJson(data);
    } catch (e) {
      if (e is DioException) {
        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
