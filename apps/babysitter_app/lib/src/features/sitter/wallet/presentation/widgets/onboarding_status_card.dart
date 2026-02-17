import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/stripe_connect_status.dart';

/// A card widget that displays the current Stripe Connect onboarding status
/// and provides an action button based on the current state.
class OnboardingStatusCard extends StatelessWidget {
  final StripeConnectStatus status;
  final VoidCallback onActionPressed;
  final bool isLoading;

  const OnboardingStatusCard({
    super.key,
    required this.status,
    required this.onActionPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and status indicator
          Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  config.icon,
                  color: config.iconColor,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B2225),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      config.subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7680),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Description text
          Text(
            config.description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7680),
              height: 1.5,
            ),
          ),

          // Action button
          if (status.status != StripeConnectStatusType.complete) ...[
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.buttonColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: config.buttonColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        config.buttonText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],

          // Additional info for complete status
          if (status.status == StripeConnectStatusType.complete) ...[
            SizedBox(height: 16.h),
            _buildStatusRow(
              'Charges',
              status.chargesEnabled ? 'Enabled' : 'Disabled',
              status.chargesEnabled,
            ),
            SizedBox(height: 8.h),
            _buildStatusRow(
              'Payouts',
              status.payoutsEnabled ? 'Enabled' : 'Disabled',
              status.payoutsEnabled,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, bool isEnabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7680),
          ),
        ),
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isEnabled ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isEnabled ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _StatusConfig _getStatusConfig(StripeConnectStatusType statusType) {
    switch (statusType) {
      case StripeConnectStatusType.notStarted:
        return const _StatusConfig(
          icon: Icons.account_balance_wallet_outlined,
          iconColor: Color(0xFF6B7680),
          backgroundColor: Color(0xFFF5F5F5),
          title: 'Set Up Payouts',
          subtitle: 'Not started',
          description:
              'Connect your bank account to receive payments for completed jobs. This process is powered by Stripe for secure and fast transfers.',
          buttonText: 'Set Up Payouts',
          buttonColor: Color(0xFF89CFF0),
        );

      case StripeConnectStatusType.pending:
        return const _StatusConfig(
          icon: Icons.hourglass_empty_rounded,
          iconColor: Color(0xFFFF9800),
          backgroundColor: Color(0xFFFFF3E0),
          title: 'Verification Pending',
          subtitle: 'In review',
          description:
              'Your information has been submitted and is being reviewed. This usually takes 1-2 business days. You\'ll be notified once verified.',
          buttonText: 'Continue Setup',
          buttonColor: Color(0xFFFF9800),
        );

      case StripeConnectStatusType.restricted:
        return const _StatusConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFFF9800),
          backgroundColor: Color(0xFFFFF3E0),
          title: 'Action Required',
          subtitle: 'Incomplete setup',
          description:
              'Additional information is needed to complete your payout setup. Please continue where you left off to start receiving payments.',
          buttonText: 'Continue Setup',
          buttonColor: Color(0xFFFF9800),
        );

      case StripeConnectStatusType.complete:
        return const _StatusConfig(
          icon: Icons.check_circle_outline_rounded,
          iconColor: Color(0xFF4CAF50),
          backgroundColor: Color(0xFFE8F5E9),
          title: 'Payouts Active',
          subtitle: 'Ready to receive payments',
          description:
              'Your account is fully set up! Earnings from completed jobs will be automatically transferred to your bank account.',
          buttonText: 'View Dashboard',
          buttonColor: Color(0xFF4CAF50),
        );
    }
  }
}

class _StatusConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final Color buttonColor;

  const _StatusConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
  });
}
