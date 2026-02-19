import 'package:core/core.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';

/// Payment method types available
enum PaymentMethodType {
  googlePay,
  applePay,
  card,
}

/// A bottom sheet that lets the user select a payment method
class PaymentMethodSelector extends StatefulWidget {
  final double amount;
  final String paymentIntentClientSecret;
  final VoidCallback onPaymentSuccess;
  final Function(String error) onPaymentError;
  final VoidCallback onCancel;

  const PaymentMethodSelector({
    super.key,
    required this.amount,
    required this.paymentIntentClientSecret,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.onCancel,
  });

  /// Show the payment method selector as a bottom sheet
  static Future<void> show({
    required BuildContext context,
    required double amount,
    required String paymentIntentClientSecret,
    required VoidCallback onPaymentSuccess,
    required Function(String error) onPaymentError,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodSelector(
        amount: amount,
        paymentIntentClientSecret: paymentIntentClientSecret,
        onPaymentSuccess: () {
          Navigator.of(context).pop();
          onPaymentSuccess();
        },
        onPaymentError: (error) {
          Navigator.of(context).pop();
          onPaymentError(error);
        },
        onCancel: () {
          Navigator.of(context).pop();
          onPaymentError('Payment cancelled by user');
        },
      ),
    );
  }

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  bool _isProcessing = false;
  bool _applePayAvailable = false;
  Pay? _payClient;

  @override
  void initState() {
    super.initState();
    _checkApplePayAvailability();
  }

  Future<void> _checkApplePayAvailability() async {
    if (!Platform.isIOS) return;
    try {
      final available = await Stripe.instance.isPlatformPaySupported();
      if (mounted) {
        setState(() {
          _applePayAvailable = available;
        });
      }
      debugPrint('DEBUG: Apple Pay available: $available');
    } catch (e) {
      debugPrint('DEBUG: Error checking Apple Pay availability: $e');
    }
  }

  String _getGooglePayConfig() {
    return jsonEncode({
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
                "stripe:publishableKey": Stripe.publishableKey,
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
    });
  }

  Future<void> _handleGooglePay() async {
    if (_isProcessing) return;
    
    // Initialize pay client if not already done
    if (_payClient == null) {
      try {
        _payClient = Pay({
          PayProvider.google_pay: PaymentConfiguration.fromJsonString(_getGooglePayConfig()),
        });
      } catch (e) {
        debugPrint('DEBUG: Error initializing Google Pay: $e');
        widget.onPaymentError('Google Pay is not available on this device');
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      debugPrint('DEBUG: Starting native Google Pay flow...');

      final paymentItems = [
        PaymentItem(
          label: 'Special Needs Sitters',
          amount: widget.amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      final result = await _payClient!.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      debugPrint('DEBUG: Google Pay result received');

      // Extract token from result
      final paymentData = result['paymentMethodData'];
      final tokenizationData = paymentData?['tokenizationData'];
      final tokenString = tokenizationData?['token'];

      if (tokenString == null) {
        throw Exception('No token received from Google Pay');
      }

      final tokenJson = jsonDecode(tokenString);
      final stripeTokenId = tokenJson['id'];

      debugPrint('DEBUG: Stripe token ID: $stripeTokenId');

      // Create PaymentMethod from token
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.cardFromToken(
          paymentMethodData: PaymentMethodDataCardFromToken(
            token: stripeTokenId,
          ),
        ),
      );

      debugPrint('DEBUG: Payment method created: ${paymentMethod.id}');

      // Confirm the PaymentIntent
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.paymentIntentClientSecret,
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
            paymentMethodId: paymentMethod.id,
          ),
        ),
      );

      debugPrint('DEBUG: Payment confirmed via Google Pay');
      widget.onPaymentSuccess();
    } catch (e) {
      debugPrint('DEBUG: Google Pay error: $e');
      final errorMsg = e.toString();
      if (errorMsg.contains('canceled') || errorMsg.contains('cancelled')) {
        // User cancelled, don't show error
        setState(() => _isProcessing = false);
      } else {
        widget.onPaymentError(errorMsg);
      }
    }
  }

  Future<void> _handleCardPayment() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      debugPrint('DEBUG: Starting Stripe Payment Sheet...');

      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: widget.paymentIntentClientSecret,
          merchantDisplayName: 'Special Needs Sitters',
          applePay: Platform.isIOS
              ? const PaymentSheetApplePay(merchantCountryCode: 'US')
              : null,
          style: ThemeMode.system,
        ),
      );

      // Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      debugPrint('DEBUG: Payment completed via Stripe Payment Sheet');
      widget.onPaymentSuccess();
    } on StripeException catch (e) {
      debugPrint('DEBUG: Stripe error: ${e.error.localizedMessage}');
      if (e.error.code == FailureCode.Canceled) {
        setState(() => _isProcessing = false);
        widget.onCancel(); // Notify parent that user cancelled
      } else {
        widget.onPaymentError(e.error.localizedMessage ?? 'Payment failed');
      }
    } catch (e) {
      debugPrint('DEBUG: Payment error: $e');
      widget.onPaymentError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B1736),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Amount
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Loading indicator
              if (_isProcessing)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                // Google Pay button (Android only) - always show, handle errors on tap
                if (Platform.isAndroid)
                  _buildPaymentButton(
                    onTap: _handleGooglePay,
                    icon: Icons.account_balance_wallet,
                    label: 'Google Pay',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),

                if (Platform.isAndroid)
                  const SizedBox(height: 12),

                // Apple Pay button (iOS only)
                if (Platform.isIOS && _applePayAvailable)
                  _buildPaymentButton(
                    onTap: _handleCardPayment, // Apple Pay is handled within Stripe Payment Sheet
                    icon: Icons.apple,
                    label: 'Apple Pay',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),

                if (Platform.isIOS && _applePayAvailable)
                  const SizedBox(height: 12),

                // Card payment button
                _buildPaymentButton(
                  onTap: _handleCardPayment,
                  icon: Icons.credit_card,
                  label: 'Credit / Debit Card',
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),

                const SizedBox(height: 16),

                // Cancel button
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
