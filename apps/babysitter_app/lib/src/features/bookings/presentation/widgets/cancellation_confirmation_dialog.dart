import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

enum CancellationTier {
  moreThan48Hours, // 48+ hours - no fee
  within24To48Hours, // 24-48 hours - 25% fee
  lessThan24Hours, // Less than 24 hours - 50% fee
  lessThan12HoursOrNoShow, // Less than 12 hours - 75% fee
}

CancellationTier getCancellationTier(DateTime scheduledDate) {
  final now = DateTime.now();
  final hoursUntilBooking = scheduledDate.difference(now).inHours;

  if (hoursUntilBooking >= 48) {
    return CancellationTier.moreThan48Hours;
  } else if (hoursUntilBooking >= 24) {
    return CancellationTier.within24To48Hours;
  } else if (hoursUntilBooking >= 12) {
    return CancellationTier.lessThan24Hours;
  } else {
    return CancellationTier.lessThan12HoursOrNoShow;
  }
}

Future<bool?> showCancellationConfirmationDialog(
  BuildContext context, {
  required CancellationTier tier,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CancellationConfirmationDialog(tier: tier),
  );
}

class CancellationConfirmationDialog extends StatelessWidget {
  final CancellationTier tier;

  const CancellationConfirmationDialog({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child:
                    const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              _getTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B1220),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Content
            _buildContent(),

            const SizedBox(height: 20),

            // Buttons
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (tier) {
      case CancellationTier.moreThan48Hours:
        return '48+ Hours Before Booking';
      case CancellationTier.within24To48Hours:
        return '24 to 48 Hours Before Booking';
      case CancellationTier.lessThan24Hours:
        return 'Less Than 24 Hours';
      case CancellationTier.lessThan12HoursOrNoShow:
        return 'Less Than 12 Hours or No-Show';
    }
  }

  Widget _buildContent() {
    switch (tier) {
      case CancellationTier.moreThan48Hours:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_box, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your booking has been canceled.\nNo cancellation fee was charged since it was more than 48 hours in advance.\nYour refund will be processed shortly.',
                    style: _bodyStyle(),
                  ),
                ),
              ],
            ),
          ],
        );

      case CancellationTier.within24To48Hours:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFD97706), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You're canceling within 24-48 hours of the booking.",
                    style: _bodyStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('A 25% cancellation fee will apply:', style: _bodyStyle()),
            const SizedBox(height: 4),
            _bulletPoint('20% goes to the sitter'),
            _bulletPoint('5% goes to the platform'),
            const SizedBox(height: 8),
            Text('The rest will be refunded to your account.',
                style: _bodyStyle()),
          ],
        );

      case CancellationTier.lessThan24Hours:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFD97706), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You're canceling less than 24 hours before the booking.",
                    style: _bodyStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('A 50% cancellation fee applies:', style: _bodyStyle()),
            const SizedBox(height: 4),
            _bulletPoint('35% goes to the sitter'),
            _bulletPoint('15% goes to the platform'),
            const SizedBox(height: 8),
            Text('The remaining amount will be refunded to your account.',
                style: _bodyStyle()),
          ],
        );

      case CancellationTier.lessThan12HoursOrNoShow:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFD97706), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You're canceling within 12 hours or did not show up.",
                    style: _bodyStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'A 75% fee of the total booking will be charged to compensate the sitter.\nOnly 25% of the booking total will be refunded to you.',
              style: _bodyStyle(),
            ),
          ],
        );
    }
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
          Expanded(child: Text(text, style: _bodyStyle())),
        ],
      ),
    );
  }

  TextStyle _bodyStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF4B5563),
      height: 1.4,
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (tier == CancellationTier.moreThan48Hours) {
      // Only Submit button for 48+ hours
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTokens.primaryBlue,
            foregroundColor: AppColors.textOnButton,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    // Go Back + Confirm Cancellation for other tiers
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Go Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.primaryBlue,
                foregroundColor: AppColors.textOnButton,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
