/// Result of a direct booking creation
class BookingResult {
  final String message;
  final String applicationId;

  const BookingResult({
    required this.message,
    required this.applicationId,
  });
}
