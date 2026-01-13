import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class BottomStickyCta extends StatelessWidget {
  final VoidCallback onAddPaymentMethod;
  final VoidCallback onNext;

  const BottomStickyCta({
    super.key,
    required this.onAddPaymentMethod,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BookingUiTokens.pageBackground
          .withOpacity(0.95), // Slight blur effect bg
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onAddPaymentMethod,
            child: const Text(
              'Add Payment Method',
              style: BookingUiTokens.addMethodLink,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: BookingUiTokens.ctaButtonHeight,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingUiTokens.ctaButtonBackground,
                foregroundColor: BookingUiTokens.ctaButtonText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(BookingUiTokens.ctaButtonRadius),
                ),
              ),
              child: const Text(
                'Next',
                style: BookingUiTokens.ctaText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
