import 'package:dio/dio.dart';

import '../dtos/submit_application_request_dto.dart';

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
}
