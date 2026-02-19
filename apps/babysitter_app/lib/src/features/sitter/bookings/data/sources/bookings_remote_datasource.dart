import 'package:dio/dio.dart';

import '../models/booking_model.dart';
import '../models/booking_session_model.dart';
import '../models/clock_out_result_model.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for bookings API calls.
class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  /// Get sitter's bookings via GET /sitters/bookings.
  Future<List<BookingModel>> getBookings({String? tab}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tab != null) {
        queryParams['tab'] = tab;
      }

      debugPrint(
          'DEBUG: Sitter Bookings Request: GET /sitters/bookings${queryParams.isNotEmpty ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}' : ''}');
      final response = await _dio.get(
        '/sitters/bookings',
        queryParameters: queryParams,
      );
      debugPrint('DEBUG: Sitter Bookings Response Status: ${response.statusCode}');
      debugPrint('DEBUG: Sitter Bookings Raw Response: ${response.data}');

      final data = response.data['data'] as Map<String, dynamic>;
      final bookings = data['bookings'] as List;
      debugPrint('DEBUG: Sitter Bookings Count: ${bookings.length}');

      final result = bookings
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();

      for (var i = 0; i < result.length; i++) {
        debugPrint(
            'DEBUG: Parsed booking[$i]: id=${result[i].id}, applicationId=${result[i].applicationId}, title=${result[i].title}');
      }

      return result;
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Sitter Bookings Error: ${e.message}');
        debugPrint('DEBUG: Sitter Bookings Error Response: ${e.response?.data}');
        debugPrint(
            'DEBUG: Sitter Bookings Error Headers: ${e.requestOptions.headers}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Get an active booking session via GET /sitters/bookings/{id}/session.
  Future<BookingSessionModel> getBookingSession(String applicationId) async {
    try {
      debugPrint(
          'DEBUG: Booking Session Request: GET /sitters/bookings/$applicationId/session');
      final response =
          await _dio.get('/sitters/bookings/$applicationId/session');
      debugPrint('DEBUG: Booking Session Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      return BookingSessionModel.fromJson(data);
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Booking Session Error: ${e.message}');
        debugPrint('DEBUG: Booking Session Error Response: ${e.response?.data}');
        debugPrint(
            'DEBUG: Booking Session Error Headers: ${e.requestOptions.headers}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Post sitter location updates via POST /sitters/bookings/{id}/location.
  Future<void> postBookingLocation(
    String applicationId, {
    required double latitude,
    required double longitude,
  }) async {
    try {
      final payload = {
        'latitude': latitude,
        'longitude': longitude,
      };
      debugPrint(
          'DEBUG: Booking Location Request: POST /sitters/bookings/$applicationId/location $payload');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/location',
        data: payload,
      );
      debugPrint('DEBUG: Booking Location Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Booking Location Error: ${e.message}');
        debugPrint('DEBUG: Booking Location Error Response: ${e.response?.data}');
        debugPrint(
            'DEBUG: Booking Location Error Headers: ${e.requestOptions.headers}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Pause the current booking session via POST /sitters/bookings/{id}/pause.
  Future<DateTime> pauseBooking(String applicationId,
      {required String reason}) async {
    try {
      final payload = {'reason': reason};
      debugPrint(
          'DEBUG: Pause Booking Request: POST /sitters/bookings/$applicationId/pause $payload');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/pause',
        data: payload,
      );
      debugPrint('DEBUG: Pause Booking Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      final pausedAtStr = data['pausedAt'] as String;
      return DateTime.parse(pausedAtStr);
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Pause Booking Error: ${e.message}');
        debugPrint('DEBUG: Pause Booking Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Resume the current booking session via POST /sitters/bookings/{id}/resume.
  Future<void> resumeBooking(String applicationId) async {
    try {
      debugPrint(
          'DEBUG: Resume Booking Request: POST /sitters/bookings/$applicationId/resume');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/resume',
      );
      debugPrint('DEBUG: Resume Booking Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Resume Booking Error: ${e.message}');
        debugPrint('DEBUG: Resume Booking Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  /// Clock out of the current booking session via POST /sitters/bookings/{id}/clock-out.
  Future<ClockOutResultModel> clockOutBooking(String applicationId) async {
    try {
      debugPrint(
          'DEBUG: Clock Out Request: POST /sitters/bookings/$applicationId/clock-out');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/clock-out',
      );
      debugPrint('DEBUG: Clock Out Response Status: ${response.statusCode}');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return ClockOutResultModel.fromJson(data);
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Clock Out Error: ${e.message}');
        debugPrint('DEBUG: Clock Out Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
