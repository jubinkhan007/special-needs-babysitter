import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/routes.dart';

/// Screen to initiate identity verification for the background check flow.
class VerifyIdentityScreen extends StatelessWidget {
  const VerifyIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Rest of the content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    // Title
                    Text(
                      'Verify Your Identity',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    Text(
                      'Before we run your background check, we need to confirm your identity. This prevents fake profiles and protects families. This step confirms you are a real person and prevents fake or fraudulent sitter profiles.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // Hero Image
                    Center(
                      child: Image.asset(
                        'assets/images/verify_identity_hero.png',
                        width: 280.w,
                        fit: BoxFit.contain,
                      ),
                    ),
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
                        context.push(Routes.sitterBackgroundCheck);
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
                        'Begin Identity Verification',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Footer Text
                  Text(
                    'We use a secure third-party provider to verify your identity. No ID images are stored in our app.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
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
}
