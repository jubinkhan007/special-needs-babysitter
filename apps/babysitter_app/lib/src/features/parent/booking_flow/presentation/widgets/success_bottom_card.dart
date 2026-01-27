import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class SuccessBottomCard extends StatelessWidget {
  final VoidCallback onViewStatus;
  final VoidCallback onCancel;
  final String sitterName;

  const SuccessBottomCard({
    super.key,
    required this.onViewStatus,
    required this.onCancel,
    required this.sitterName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Subtle shadow
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        36,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Booking Request Sent!',
            style: BookingUiTokens.successTitle,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Body
          Text(
            'Your request has been sent to $sitterName.\nYou will be notified if they accept\nor decline.',
            style: BookingUiTokens.successBody,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Primary Button
          SizedBox(
            width: 280, // Fixed width as per spec/screenshot
            height: 62,
            child: ElevatedButton(
              onPressed: onViewStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingUiTokens.primaryButtonBg,
                foregroundColor: BookingUiTokens.ctaButtonText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'View Request Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Secondary Button
          GestureDetector(
            onTap: onCancel,
            child: const Text(
              'Cancel Request',
              style: TextStyle(
                fontSize: 18, // Reduced from 24-26
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A8186),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
