import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

/// Sitter home header with greeting, location, and notification bell.
class SitterHomeHeader extends StatelessWidget {
  final String userName;
  final String location;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final bool isVerified;

  const SitterHomeHeader({
    super.key,
    required this.userName,
    required this.location,
    this.avatarUrl,
    this.onNotificationTap,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // Profile Avatar - Slightly smaller for Figma match
          CircleAvatar(
            radius: 18.w,
            backgroundColor: AppColors.neutral10,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Icon(Icons.person, size: 20.w, color: AppColors.textMuted)
                : null,
          ),
          SizedBox(width: 10.w),
          // Greeting and Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi, $userName',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified,
                        size: 16.w,
                        color: const Color(0xFF2B89D6), // Brand blue
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification Bell
          IconButton(
            onPressed: onNotificationTap,
            icon: Icon(
              Icons.notifications_none_outlined,
              size: 24.w,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
