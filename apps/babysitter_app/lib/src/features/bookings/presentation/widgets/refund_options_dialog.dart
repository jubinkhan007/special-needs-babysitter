import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

enum RefundOption {
  accountCredit,
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
              'Select your preferred refund option',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            // Account Credit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(RefundOption.accountCredit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Account Credit (Instant)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Original Payment Method button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pop(RefundOption.originalPaymentMethod),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Original Payment Method(2-3 Days)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
