import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../models/job_request_details_model.dart';

class JobRequestPresignedUploadResponse {
  final String uploadUrl;
  final String publicUrl;

  JobRequestPresignedUploadResponse({
    required this.uploadUrl,
    required this.publicUrl,
  });

  factory JobRequestPresignedUploadResponse.fromJson(
      Map<String, dynamic> json) {
    return JobRequestPresignedUploadResponse(
      uploadUrl: json['uploadUrl'] as String,
      publicUrl: json['publicUrl'] as String,
    );
  }
}

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
      print('DEBUG: Job Request Details Response Body: ${response.data}');

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

  /// Accept a job invitation or direct booking
  /// Uses /applications/{id}/accept for invitations
  /// Uses /applications/{id}/accept-booking for direct bookings
  Future<void> acceptJobInvitation(
    String applicationId, {
    required String applicationType,
  }) async {
    try {
      final endpoint = applicationType == 'direct_booking'
          ? '/applications/$applicationId/accept-booking'
          : '/applications/$applicationId/accept';

      print('DEBUG: Accept Job Request: POST $endpoint');
      final response = await _dio.post(endpoint);
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

  /// Decline a job invitation or direct booking
  /// Uses /applications/{id}/decline for invitations
  /// Uses /applications/{id}/decline-booking for direct bookings
  /// Sends reason and otherReason in request body
  Future<void> declineJobInvitation(
    String applicationId, {
    required String applicationType,
    required String reason,
    String? otherReason,
  }) async {
    try {
      final endpoint = applicationType == 'direct_booking'
          ? '/applications/$applicationId/decline-booking'
          : '/applications/$applicationId/decline';

      print('DEBUG: Decline Job Request: POST $endpoint');
      print('DEBUG: Decline Application ID: $applicationId');
      print('DEBUG: Decline Application Type: $applicationType');

      final data = {
        'reason': reason,
        if (otherReason != null && otherReason.isNotEmpty)
          'otherReason': otherReason,
      };

      print('DEBUG: Decline Job Request Body: $data');

      final response = await _dio.post(endpoint, data: data);
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

  /// Clock in to a booking
  /// Uses /sitters/bookings/{id}/clock-in
  /// Requires latitude and longitude from device location
  Future<void> clockInBooking(
    String applicationId, {
    required double latitude,
    required double longitude,
  }) async {
    try {
      final endpoint = '/sitters/bookings/$applicationId/clock-in';
      final data = {
        'latitude': latitude,
        'longitude': longitude,
      };
      print('DEBUG: Clock In Request: POST $endpoint');
      print('DEBUG: Clock In Request Body: $data');
      final response = await _dio.post(endpoint, data: data);
      print('DEBUG: Clock In Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Clock In Error: ${e.message}');
        print('DEBUG: Clock In Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Upload cancellation evidence and return public URL.
  Future<String> uploadCancellationEvidence(File file) async {
    try {
      final fileName = path.basename(file.path);
      final extension = path.extension(fileName).toLowerCase();
      String contentType;
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          contentType = 'image/jpeg';
          break;
        case '.png':
          contentType = 'image/png';
          break;
        case '.pdf':
          contentType = 'application/pdf';
          break;
        default:
          contentType = 'application/octet-stream';
      }

      final presigned = await _getCancellationPresignedUrl(
        fileName: fileName,
        contentType: contentType,
      );

      final uploadDio = Dio();
      final length = await file.length();
      await uploadDio.put(
        presigned.uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: length,
            Headers.contentTypeHeader: contentType,
          },
        ),
      );

      return presigned.publicUrl;
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

  Future<JobRequestPresignedUploadResponse> _getCancellationPresignedUrl({
    required String fileName,
    required String contentType,
  }) async {
    final response = await _dio.post(
      '/uploads/presign',
      data: {
        'uploadType': 'cancellation-evidence',
        'fileName': fileName,
        'contentType': contentType,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return JobRequestPresignedUploadResponse.fromJson(data);
  }

  /// Cancel a sitter booking.
  /// Uses /sitters/bookings/{id}/cancel
  Future<void> cancelBooking(
    String applicationId, {
    required String reason,
    String? fileUrl,
  }) async {
    try {
      final endpoint = '/sitters/bookings/$applicationId/cancel';
      final data = {
        'reason': reason,
        if (fileUrl != null && fileUrl.isNotEmpty) 'fileUrl': fileUrl,
      };
      print('DEBUG: Cancel Booking Request: POST $endpoint');
      print('DEBUG: Cancel Booking Request Body: $data');
      final response = await _dio.post(endpoint, data: data);
      print('DEBUG: Cancel Booking Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Cancel Booking Error: ${e.message}');
        print('DEBUG: Cancel Booking Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
