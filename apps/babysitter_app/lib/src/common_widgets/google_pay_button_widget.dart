import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';

/// A widget that displays a Google Pay button and handles the payment flow.
///
/// This uses the native Google Pay SDK to collect payment details,
/// then creates a Stripe PaymentMethod from the token.
class GooglePayButtonWidget extends StatefulWidget {
  final double amount;
  final String paymentIntentClientSecret;
  final VoidCallback onPaymentSuccess;
  final Function(String error) onPaymentError;
  final bool isLoading;

  const GooglePayButtonWidget({
    super.key,
    required this.amount,
    required this.paymentIntentClientSecret,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.isLoading = false,
  });

  @override
  State<GooglePayButtonWidget> createState() => _GooglePayButtonWidgetState();
}

class _GooglePayButtonWidgetState extends State<GooglePayButtonWidget> {
  bool _isProcessing = false;
  late final Pay _payClient;
  bool _googlePayAvailable = false;

  @override
  void initState() {
    super.initState();
    _initGooglePay();
  }

  Future<void> _initGooglePay() async {
    _payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString('''
{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "stripe:version": "2020-08-27",
            "stripe:publishableKey": "${Stripe.publishableKey}"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD", "AMEX", "DISCOVER"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": false
        }
      }
    ],
    "merchantInfo": {
      "merchantName": "Special Needs Sitters"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}
'''),
    });

    try {
      final available = await _payClient.userCanPay(PayProvider.google_pay);
      if (mounted) {
        setState(() {
          _googlePayAvailable = available;
        });
      }
      print('DEBUG: Google Pay available (native): $available');
    } catch (e) {
      print('DEBUG: Error checking Google Pay availability: $e');
    }
  }

  Future<void> _handleGooglePayPressed() async {
    if (_isProcessing || widget.isLoading) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      print('DEBUG: Starting native Google Pay flow...');
      print('DEBUG: Amount: ${widget.amount}');

      // Create payment items
      final paymentItems = [
        PaymentItem(
          label: 'Special Needs Sitters',
          amount: widget.amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // Show Google Pay sheet and get result
      final result = await _payClient.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      print('DEBUG: Google Pay result received');
      print('DEBUG: Result keys: ${result.keys.toList()}');

      // Extract the token from the result
      final paymentData = result['paymentMethodData'];
      if (paymentData == null) {
        throw Exception('No payment method data received');
      }

      final tokenizationData = paymentData['tokenizationData'];
      if (tokenizationData == null) {
        throw Exception('No tokenization data received');
      }

      final tokenString = tokenizationData['token'];
      if (tokenString == null) {
        throw Exception('No token received');
      }

      print('DEBUG: Token string received, parsing...');

      // Parse the token JSON to get the Stripe token ID
      final tokenJson = jsonDecode(tokenString);
      final stripeTokenId = tokenJson['id'];

      print('DEBUG: Stripe token ID: $stripeTokenId');

      // Create a PaymentMethod from the token
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.cardFromToken(
          paymentMethodData: PaymentMethodDataCardFromToken(
            token: stripeTokenId,
          ),
        ),
      );

      print('DEBUG: Payment method created: ${paymentMethod.id}');

      // Confirm the PaymentIntent with the payment method
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.paymentIntentClientSecret,
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
            paymentMethodId: paymentMethod.id,
          ),
        ),
      );

      print('DEBUG: Payment confirmed successfully via Google Pay');
      widget.onPaymentSuccess();
    } catch (e) {
      print('DEBUG: Google Pay error: $e');
      if (e.toString().contains('canceled') || e.toString().contains('cancelled')) {
        widget.onPaymentError('Payment cancelled');
      } else {
        widget.onPaymentError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_googlePayAvailable) {
      return const SizedBox.shrink();
    }

    final isLoading = _isProcessing || widget.isLoading;

    return GestureDetector(
      onTap: isLoading ? null : _handleGooglePayPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[300] : Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://www.gstatic.com/instantbuy/svg/dark_gpay.svg',
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.payment, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Google Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
