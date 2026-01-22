import '../../data/models/booking_model.dart';

/// Repository interface for bookings operations.
abstract class BookingsRepository {
  /// Get all bookings for the current sitter.
  Future<List<BookingModel>> getBookings({String? tab});
}
