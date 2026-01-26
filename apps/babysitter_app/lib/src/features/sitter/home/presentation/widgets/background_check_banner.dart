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
        constraints: BoxConstraints(minHeight: 140.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF53B1F2), // Lighter Blue
              Color(0xFF2B89D6), // Darker Blue
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2B89D6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration (optional subtle circles/glows could go here)

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 100.w, 20.h),
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
                  SizedBox(height: 8.h),
                  Text(
                    _getDescription(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Badge Icon on the right
            Positioned(
              right: 16.w,
              top: 30.h,
              child: _buildBadge(),
            ),
          ],
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
        // "You're eligible for Institution Clearance."
        return "You're eligible for\nInstitution Clearance.";
    }
  }

  String _getDescription() {
    switch (status) {
      case 'pending':
        return 'We are reviewing your documents. This usually takes 24-48 hours.';
      case 'rejected':
        return 'We could not verify your identity. Please contact support.';
      default:
        return 'Complete the 3-step process to become an Institution-Cleared Sitter.';
    }
  }

  Widget _buildBadge() {
    IconData icon;
    Color color;

    switch (status) {
      case 'pending':
        icon = Icons.hourglass_top_rounded;
        color = Colors.white;
        break;
      case 'rejected':
        icon = Icons.error_outline_rounded;
        color = Colors.white;
        break;
      default:
        // Verified badge looking icon
        return Container(
          width: 56.w,
          height: 56.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.verified_rounded,
              size: 56.w, // Fill the circle
              color: const Color(0xFF2B89D6),
            ),
          ),
        );
    }

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32.w,
          color: color,
        ),
      ),
    );
  }
}
