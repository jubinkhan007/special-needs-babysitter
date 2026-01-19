/// Result of creating a Stripe payment intent
class PaymentIntentResult {
  final String clientSecret;
  final String paymentIntentId;

  const PaymentIntentResult({
    required this.clientSecret,
    required this.paymentIntentId,
  });
}
