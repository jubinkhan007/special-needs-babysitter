/// Result for checking email/phone uniqueness
class UniquenessCheckResult {
  final bool success;
  final bool available;
  final String message;

  const UniquenessCheckResult({
    required this.success,
    required this.available,
    required this.message,
  });
}
