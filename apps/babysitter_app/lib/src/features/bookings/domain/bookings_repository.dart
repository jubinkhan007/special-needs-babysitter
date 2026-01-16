import 'booking.dart';
import 'booking_details.dart';

abstract class BookingsRepository {
  Future<List<Booking>> getBookings();
  Future<BookingDetails> getBookingDetails(String bookingId);
}
