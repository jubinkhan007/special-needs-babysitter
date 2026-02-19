import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class SuccessBottomCard extends StatelessWidget {
  final VoidCallback onViewStatus;
  final VoidCallback onCancel;
  final String sitterName;
  final String bookingStatus;

  const SuccessBottomCard({
    super.key,
    required this.onViewStatus,
    required this.onCancel,
    required this.sitterName,
    this.bookingStatus = 'Pending',
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

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(bookingStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getStatusColor(bookingStatus)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(bookingStatus),
                  color: _getStatusColor(bookingStatus),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Status: $bookingStatus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(bookingStatus),
                  ),
                ),
              ],
            ),
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
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'awaiting confirmation':
        return const Color(0xFFD97706); // Amber
      case 'confirmed':
      case 'accepted':
        return const Color(0xFF059669); // Green
      case 'declined':
      case 'rejected':
        return AppColors.error; // Red
      case 'cancelled':
        return const Color(0xFF6B7280); // Grey
      case 'completed':
        return const Color(0xFF2563EB); // Blue
      default:
        return const Color(0xFFD97706); // Default amber
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'awaiting confirmation':
        return Icons.access_time;
      case 'confirmed':
      case 'accepted':
        return Icons.check_circle;
      case 'declined':
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.block;
      case 'completed':
        return Icons.task_alt;
      default:
        return Icons.access_time;
    }
  }
}
