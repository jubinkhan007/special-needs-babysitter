import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Banner shown on the sitter home screen when a background check is required.
class BackgroundCheckBanner extends StatelessWidget {
  final VoidCallback onStart;

  const BackgroundCheckBanner({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_check_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Background Check Required',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 200
                      .w, // Limit width to avoid overlapping button if it's on the right
                  child: Text(
                    'Complete your background check to apply for jobs and appear to families.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Start Button positioned on the right
          Positioned(
            right: 20.w,
            bottom: 20.h,
            child: SizedBox(
              height: 36.h,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF00B0FF), // Vivid blue
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
