import 'entities/booking_result.dart';

/// Repository interface for booking operations
abstract class BookingsRepository {
  /// Create a direct booking with a specific sitter
  /// Returns [BookingResult] on success
  Future<BookingResult> createDirectBooking(Map<String, dynamic> data);
}
