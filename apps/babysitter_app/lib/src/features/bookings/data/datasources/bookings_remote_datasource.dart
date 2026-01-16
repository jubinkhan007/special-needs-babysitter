import 'package:dio/dio.dart';
import '../models/parent_booking_dto.dart';
import '../models/booking_details_dto.dart';

class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  Future<List<ParentBookingDto>> getBookings() async {
    print('DEBUG: BookingsRemoteDataSource.getBookings called');
    try {
      final response = await _dio.get('/parents/bookings');
      final responseData = response.data['data'];
      if (responseData == null) {
        return [];
      }
      final data = ParentBookingsResponseDto.fromJson(responseData);
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
}
