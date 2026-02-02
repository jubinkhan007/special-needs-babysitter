import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';

class BottomCtaBar extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BottomCtaBar({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.surfaceWhite, // Bar background usually white
      child: SafeArea(
        // Handle bottom notch
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTokens.screenHorizontalPadding.w,
            vertical: 16.h,
          ),
          child: SizedBox(
            height: 52.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.buttonRadius.r),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppTokens.fontFamily,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
