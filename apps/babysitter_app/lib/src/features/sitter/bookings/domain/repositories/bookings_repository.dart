import '../../data/models/booking_model.dart';
import '../../data/models/booking_session_model.dart';

/// Repository interface for bookings operations.
abstract class BookingsRepository {
  /// Get all bookings for the current sitter.
  Future<List<BookingModel>> getBookings({String? tab});

  /// Get the current booking session for an application.
  Future<BookingSessionModel> getBookingSession(String applicationId);

  /// Post the sitter's live location for an active booking.
  Future<void> postBookingLocation(
    String applicationId, {
    required double latitude,
    required double longitude,
  });
}
