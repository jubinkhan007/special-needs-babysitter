import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Banner shown on the sitter home screen when a background check is required.
class BackgroundCheckBanner extends StatelessWidget {
  final VoidCallback onStart;
  final String status; // 'not_started', 'pending', 'rejected'

  const BackgroundCheckBanner({
    super.key,
    required this.onStart,
    this.status = 'not_started',
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'approved') {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onStart,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 120.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/banner/background_check_required.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 96.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getTitle(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Inter',
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        _getDescription(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'Inter',
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _BannerCta(
                        label: _getCtaLabel(),
                        onTap: onStart,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16.w,
                  top: 22.h,
                  child: Image.asset(
                    'assets/images/banner/required_bg_check.png',
                    width: 54.w,
                    height: 54.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (status) {
      case 'pending':
        return 'Verification in Progress';
      case 'rejected':
        return 'Verification Failed';
      default:
        return 'Background\nCheck Required';
    }
  }

  String _getDescription() {
    switch (status) {
      case 'pending':
        return 'We are reviewing your documents. This usually takes 24-48 hours.';
      case 'rejected':
        return 'We could not verify your identity. Please contact support.';
      default:
        return 'Complete your background check to\napply for jobs and appear to families.';
    }
  }

  String _getCtaLabel() {
    switch (status) {
      case 'pending':
        return 'View Status';
      case 'rejected':
        return 'Try Again';
      default:
        return 'Start Verification';
    }
  }
}

class _BannerCta extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BannerCta({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_forward_ios, size: 10.sp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
