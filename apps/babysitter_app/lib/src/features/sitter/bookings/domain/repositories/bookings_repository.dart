import '../../data/models/booking_model.dart';
import '../../data/models/booking_session_model.dart';
import '../../data/models/clock_out_result_model.dart';

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

  /// Pause the current booking session.
  Future<DateTime> pauseBooking(String applicationId, {required String reason});

  /// Resume the current booking session.
  Future<void> resumeBooking(String applicationId);

  /// Clock out of the current booking session.
  Future<ClockOutResultModel> clockOutBooking(String applicationId);
}
