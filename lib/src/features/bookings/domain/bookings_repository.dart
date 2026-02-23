import 'booking.dart';
import 'booking_details.dart';
import 'booking_location.dart';

abstract class BookingsRepository {
  Future<List<Booking>> getBookings();
  Future<BookingDetails> getBookingDetails(String bookingId);
  Future<BookingLocation> getBookingLocation(String bookingId);
}
