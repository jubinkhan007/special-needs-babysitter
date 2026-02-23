/// Result of a direct booking creation
class BookingResult {
  final String message;
  final String jobId;
  final String clientSecret;
  final String paymentIntentId;
  final int amount;
  final int platformFee;

  const BookingResult({
    required this.message,
    required this.jobId,
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
    required this.platformFee,
  });
}
