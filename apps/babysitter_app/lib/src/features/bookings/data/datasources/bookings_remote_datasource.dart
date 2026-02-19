import 'package:dio/dio.dart';
import '../models/parent_booking_dto.dart';
import '../models/booking_details_dto.dart';
import '../models/booking_location_dto.dart';
import 'package:flutter/foundation.dart';

class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  Future<List<ParentBookingDto>> getBookings() async {
    debugPrint('DEBUG: BookingsRemoteDataSource.getBookings called');
    try {
      final response = await _dio.get('/parents/bookings');
      debugPrint(
          'DEBUG: BookingsRemoteDataSource.getBookings raw response: ${response.data}');
      final responseData = response.data['data'];
      if (responseData == null) {
        debugPrint(
            'DEBUG: BookingsRemoteDataSource.getBookings responseData is null');
        return [];
      }
      final data = ParentBookingsResponseDto.fromJson(responseData);
      debugPrint(
          'DEBUG: BookingsRemoteDataSource.getBookings parsed ${data.bookings.length} bookings');
      for (var b in data.bookings) {
        debugPrint('DEBUG: Booking id=${b.id}, status=${b.status}');
      }
      return data.bookings;
    } catch (e) {
      debugPrint('DEBUG: BookingsRemoteDataSource error: $e');
      rethrow;
    }
  }

  Future<BookingDetailsDto> getBookingDetails(String bookingId) async {
    debugPrint('DEBUG: getBookingDetails called for $bookingId');
    try {
      final response = await _dio.get('/parents/bookings/$bookingId');
      debugPrint('DEBUG: getBookingDetails raw response: ${response.data}');
      // API returns { "success": true, "data": { ... } }
      final dto = BookingDetailsResponseDto.fromJson(response.data);
      debugPrint('DEBUG: getBookingDetails parsed - sitter firstName: ${dto.data.sitter?.firstName}');
      debugPrint('DEBUG: getBookingDetails parsed - sitter lastName: ${dto.data.sitter?.lastName}');
      debugPrint('DEBUG: getBookingDetails parsed - sitter skills: ${dto.data.sitter?.skills}');
      return dto.data;
    } catch (e) {
      debugPrint('DEBUG: getBookingDetails error: $e');
      rethrow;
    }
  }

  Future<BookingLocationDto> getBookingLocation(String bookingId) async {
    debugPrint('DEBUG: getBookingLocation called for $bookingId');
    try {
      final response = await _dio.get('/parents/bookings/$bookingId/location');
      final dto = BookingLocationResponseDto.fromJson(response.data);
      return dto.data;
    } catch (e) {
      debugPrint('DEBUG: getBookingLocation error: $e');
      rethrow;
    }
  }
}
