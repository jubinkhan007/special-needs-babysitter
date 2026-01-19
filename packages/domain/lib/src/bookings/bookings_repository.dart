import 'entities/booking_result.dart';
import 'entities/payment_intent_result.dart';

/// Repository interface for booking operations
abstract class BookingsRepository {
  /// Create a direct booking with a specific sitter
  /// Returns [BookingResult] on success
  Future<BookingResult> createDirectBooking(Map<String, dynamic> data);

  /// Create a Stripe payment intent for a job
  /// Returns [PaymentIntentResult] on success
  Future<PaymentIntentResult> createPaymentIntent(String jobId);
}
