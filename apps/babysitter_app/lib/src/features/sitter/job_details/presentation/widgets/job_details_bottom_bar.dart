import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Sticky bottom bar with price and Apply Now button.
class JobDetailsBottomBar extends StatelessWidget {
  final double hourlyRate;
  final VoidCallback? onApply;
  final bool isLoading;

  const JobDetailsBottomBar({
    super.key,
    required this.hourlyRate,
    this.onApply,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppTokens.dividerSoft,
            width: 1,
          ),
        ),
      ),
      child: Row(
          children: [
            // Price
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(
                      text: '\$${hourlyRate.toInt()}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: '/hr',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Apply Now button
            SizedBox(
              width: 140.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          height: 1.0,
                        ),
                      ),
              ),
            ),
          ],
        ),
    );
  }
}
