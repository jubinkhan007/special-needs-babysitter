import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

enum RefundOption {
  originalPaymentMethod,
}

Future<RefundOption?> showRefundOptionsDialog(BuildContext context) {
  return showDialog<RefundOption>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const RefundOptionsDialog(),
  );
}

class RefundOptionsDialog extends StatelessWidget {
  const RefundOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child:
                    const Icon(Icons.close, size: 22, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Refund',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B1220),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            const Text(
              'Your refund will be returned to your original payment method.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            // Refund to Original Payment Method button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pop(RefundOption.originalPaymentMethod),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.primaryBlue,
                  foregroundColor: AppColors.textOnButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Refund to Original Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Processing time note
            const Center(
              child: Text(
                'Refunds typically take 2-3 business days to process.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
