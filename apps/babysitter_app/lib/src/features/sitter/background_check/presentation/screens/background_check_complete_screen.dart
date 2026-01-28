import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/routes.dart';
import '../providers/background_check_status_provider.dart';

/// Final success screen for the background check flow.
class BackgroundCheckCompleteScreen extends ConsumerWidget {
  const BackgroundCheckCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header with status bar color
            Container(
              color: const Color(0xFFE7F5FC),
              child: SafeArea(
                bottom: false,
                child: _buildAppBar(context),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Background Check\nComplete',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1D2939),
                          fontFamily: 'Inter',
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your background check has been approved.\nYou now have full access to apply for jobs.',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF667085),
                          fontFamily: 'Inter',
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    // Hero Image
                    Center(
                      child: Image.asset(
                        'assets/images/background_check_complete_hero.png',
                        width: 280.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Badge
                    _buildVerifiedBadge(),
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
            // Bottom Action Area
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.invalidate(backgroundCheckStatusProvider);
                      context.go(Routes.sitterHome);
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89CFF0), // Light blue
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Go to Dashboard',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24.w,
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: const Color(0xFF12B76A), // Green
            size: 18.w,
          ),
          SizedBox(width: 8.w),
          Text(
            'Verified Sitter',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF667085),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
