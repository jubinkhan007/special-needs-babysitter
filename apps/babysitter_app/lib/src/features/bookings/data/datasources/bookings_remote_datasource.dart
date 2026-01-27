import 'package:dio/dio.dart';
import '../models/parent_booking_dto.dart';
import '../models/booking_details_dto.dart';
import '../models/booking_location_dto.dart';

class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  Future<List<ParentBookingDto>> getBookings() async {
    print('DEBUG: BookingsRemoteDataSource.getBookings called');
    try {
      final response = await _dio.get('/parents/bookings');
      print(
          'DEBUG: BookingsRemoteDataSource.getBookings raw response: ${response.data}');
      final responseData = response.data['data'];
      if (responseData == null) {
        print(
            'DEBUG: BookingsRemoteDataSource.getBookings responseData is null');
        return [];
      }
      final data = ParentBookingsResponseDto.fromJson(responseData);
      print(
          'DEBUG: BookingsRemoteDataSource.getBookings parsed ${data.bookings.length} bookings');
      for (var b in data.bookings) {
        print('DEBUG: Booking id=${b.id}, status=${b.status}');
      }
      return data.bookings;
    } catch (e) {
      print('DEBUG: BookingsRemoteDataSource error: $e');
      rethrow;
    }
  }

  Future<BookingDetailsDto> getBookingDetails(String bookingId) async {
    print('DEBUG: getBookingDetails called for $bookingId');
    try {
      final response = await _dio.get('/parents/bookings/$bookingId');
      // API returns { "success": true, "data": { ... } }
      final dto = BookingDetailsResponseDto.fromJson(response.data);
      return dto.data;
    } catch (e) {
      print('DEBUG: getBookingDetails error: $e');
      rethrow;
    }
  }

  Future<BookingLocationDto> getBookingLocation(String bookingId) async {
    print('DEBUG: getBookingLocation called for $bookingId');
    try {
      final response = await _dio.get('/parents/bookings/$bookingId/location');
      final dto = BookingLocationResponseDto.fromJson(response.data);
      return dto.data;
    } catch (e) {
      print('DEBUG: getBookingLocation error: $e');
      rethrow;
    }
  }
}
