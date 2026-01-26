import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

class PauseClockDialog extends StatelessWidget {
  final VoidCallback onPause;
  final VoidCallback onCancel;

  const PauseClockDialog({
    super.key,
    required this.onPause,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTokens.dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.dialogRadius),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80.w,
              height: 80.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pause_rounded,
                size: 40.w,
                color: const Color(0xFFD97706),
              ),
            ),
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'Pause clock?',
              style: AppTokens.dialogTitleStyle.copyWith(
                fontSize: 24.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            
            // Message
            Text(
              'Are you sure you want to pause the clock?',
              style: AppTokens.dialogBodyStyle.copyWith(
                fontSize: 16.sp,
                color: AppTokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Buttons
            Row(
              children: [
                // Go back button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Go back',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF344054),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Pause button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTokens.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Pause',
                      style: AppTokens.dialogPrimaryBtnStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
