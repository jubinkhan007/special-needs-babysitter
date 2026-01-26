import 'package:dio/dio.dart';

import '../models/booking_model.dart';
import '../models/booking_session_model.dart';

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

      print('DEBUG: Sitter Bookings Request: GET /sitters/bookings${queryParams.isNotEmpty ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}' : ''}');
      final response = await _dio.get(
        '/sitters/bookings',
        queryParameters: queryParams,
      );
      print('DEBUG: Sitter Bookings Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      final bookings = data['bookings'] as List;

      return bookings
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Sitter Bookings Error: ${e.message}');
        print('DEBUG: Sitter Bookings Error Response: ${e.response?.data}');
        print(
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
      print(
          'DEBUG: Booking Session Request: GET /sitters/bookings/$applicationId/session');
      final response =
          await _dio.get('/sitters/bookings/$applicationId/session');
      print(
          'DEBUG: Booking Session Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      return BookingSessionModel.fromJson(data);
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Booking Session Error: ${e.message}');
        print('DEBUG: Booking Session Error Response: ${e.response?.data}');
        print(
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
      print(
          'DEBUG: Booking Location Request: POST /sitters/bookings/$applicationId/location $payload');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/location',
        data: payload,
      );
      print(
          'DEBUG: Booking Location Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Booking Location Error: ${e.message}');
        print('DEBUG: Booking Location Error Response: ${e.response?.data}');
        print(
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
      print(
          'DEBUG: Pause Booking Request: POST /sitters/bookings/$applicationId/pause $payload');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/pause',
        data: payload,
      );
      print('DEBUG: Pause Booking Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      final pausedAtStr = data['pausedAt'] as String;
      return DateTime.parse(pausedAtStr);
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Pause Booking Error: ${e.message}');
        print('DEBUG: Pause Booking Error Response: ${e.response?.data}');

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
      print(
          'DEBUG: Resume Booking Request: POST /sitters/bookings/$applicationId/resume');
      final response = await _dio.post(
        '/sitters/bookings/$applicationId/resume',
      );
      print('DEBUG: Resume Booking Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Resume Booking Error: ${e.message}');
        print('DEBUG: Resume Booking Error Response: ${e.response?.data}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
