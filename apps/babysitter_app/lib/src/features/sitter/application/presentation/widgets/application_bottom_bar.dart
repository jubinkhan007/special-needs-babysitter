import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Sticky bottom bar with Cancel and Submit buttons.
class ApplicationBottomBar extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const ApplicationBottomBar({
    super.key,
    this.onCancel,
    this.onSubmit,
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
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cancel button
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: OutlinedButton(
                  onPressed: isLoading ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTokens.primaryBlue,
                    side: BorderSide(color: AppTokens.primaryBlue, width: 1.w),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Submit button
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.primaryBlue,
                    foregroundColor: AppColors.textOnButton,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBackgroundColor:
                        AppTokens.primaryBlue.withValues(alpha: 0.6),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.textOnButton),
                          ),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            height: 1.0,
                          ),
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
