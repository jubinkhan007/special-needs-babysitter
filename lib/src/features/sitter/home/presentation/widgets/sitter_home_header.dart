import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/packages/core/core.dart';
import 'package:babysitter_app/src/features/notifications/presentation/providers/notification_providers.dart';

/// Sitter home header with greeting, location, and notification bell.
class SitterHomeHeader extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
    final unreadCount = unreadCountAsync.value ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // Profile Avatar - Slightly smaller for Figma match
          CircleAvatar(
            radius: 18.w,
            backgroundColor: AppColors.neutral10,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
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
          // Notification Bell with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
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
              if (unreadCount > 0)
                Positioned(
                  right: -4.w,
                  top: -4.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.h,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
