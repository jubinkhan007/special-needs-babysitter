import 'package:dio/dio.dart';
import '../models/job_request_details_model.dart';

/// Remote data source for job request API calls.
class JobRequestRemoteDataSource {
  final Dio _dio;

  JobRequestRemoteDataSource(this._dio);

  /// Get job request details via GET /sitters/bookings/{applicationId}.
  Future<JobRequestDetailsModel> getJobRequestDetails(
      String applicationId) async {
    try {
      print(
          'DEBUG: Job Request Details Request: GET /sitters/bookings/$applicationId');
      final response = await _dio.get('/sitters/bookings/$applicationId');
      print(
          'DEBUG: Job Request Details Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;

      return JobRequestDetailsModel.fromJson(data);
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Job Request Details Error: ${e.message}');
        print('DEBUG: Job Request Details Error Response: ${e.response?.data}');
        print(
            'DEBUG: Job Request Details Error Headers: ${e.requestOptions.headers}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Accept a job invitation via POST /applications/{id}/accept.
  Future<void> acceptJobInvitation(String applicationId) async {
    try {
      print('DEBUG: Accept Job Request: POST /applications/$applicationId/accept');
      final response = await _dio.post('/applications/$applicationId/accept');
      print('DEBUG: Accept Job Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Accept Job Error: ${e.message}');
        print('DEBUG: Accept Job Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Decline a job invitation via POST /applications/{id}/decline.
  Future<void> declineJobInvitation(String applicationId) async {
    try {
      print('DEBUG: Decline Job Request: POST /applications/$applicationId/decline');
      final response = await _dio.post('/applications/$applicationId/decline');
      print('DEBUG: Decline Job Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Decline Job Error: ${e.message}');
        print('DEBUG: Decline Job Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
