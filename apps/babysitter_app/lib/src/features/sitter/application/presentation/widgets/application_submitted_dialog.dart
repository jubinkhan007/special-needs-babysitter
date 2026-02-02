import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Success dialog shown after submitting an application.
class ApplicationSubmittedDialog extends StatelessWidget {
  final VoidCallback onViewApplications;

  const ApplicationSubmittedDialog({
    super.key,
    required this.onViewApplications,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button in top right
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  size: 24.w,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // Title
            Text(
              'Application Submitted',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF001F3D), // Deep blue from image
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            // Body text
            Text(
              'Your application has been submitted. Notification: You\'ll be notified once reviewed and if the family reaches out to you.',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF667085),
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            // Action button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: onViewApplications,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF8ED1F2), // Light blue from image
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'View My Applications',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    height: 1.0,
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
