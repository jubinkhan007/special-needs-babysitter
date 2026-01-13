import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class PaymentMethodSheet extends StatelessWidget {
  final VoidCallback onChange;
  final VoidCallback onConfirm;
  final String ctaLabel;

  const PaymentMethodSheet({
    super.key,
    required this.onChange,
    required this.onConfirm,
    this.ctaLabel = 'Confirm Payment & Address',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BookingUiTokens.bottomSheetBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: BookingUiTokens.dashedLineColor,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        18,
        24,
        MediaQuery.of(context).padding.bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: BookingUiTokens.primaryText,
                ),
              ),
              GestureDetector(
                onTap: onChange,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: BookingUiTokens.iconGrey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Selected Payment Method Row
          Row(
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.paypal,
                    color: Colors.blue, size: 28), // Asset would be better
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Paypal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: BookingUiTokens.primaryText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '*****doe@gmail.com',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: BookingUiTokens.labelText,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              const Text(
                '\$ 320',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: BookingUiTokens.primaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 60, // Large button
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingUiTokens.primaryButtonBg,
                foregroundColor: BookingUiTokens.ctaButtonText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                ctaLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
