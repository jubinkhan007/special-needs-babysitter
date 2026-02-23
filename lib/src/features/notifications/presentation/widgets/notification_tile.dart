import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/packages/core/core.dart';

import 'package:babysitter_app/src/features/notifications/models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        color: notification.isUnread
            ? AppColors.primary.withAlpha(8)
            : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread indicator
            if (notification.isUnread)
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(top: 6.h, right: 8.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              SizedBox(width: 16.w),

            // Avatar or category icon
            _buildLeading(),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: notification.isUnread
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.body.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 4.h),
                  Text(
                    _formatRelativeTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary.withAlpha(153),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (notification.actionUserAvatar != null &&
        notification.actionUserAvatar!.isNotEmpty) {
      return CircleAvatar(
        radius: 20.w,
        backgroundColor: AppColors.neutral10,
        backgroundImage: NetworkImage(notification.actionUserAvatar!),
        onBackgroundImageError: (_, _) {},
        child: notification.actionUserAvatar == null
            ? Icon(
                _categoryIcon(notification.category),
                size: 20.w,
                color: AppColors.textMuted,
              )
            : null,
      );
    }
    return CircleAvatar(
      radius: 20.w,
      backgroundColor: _categoryColor(notification.category).withAlpha(25),
      child: Icon(
        _categoryIcon(notification.category),
        size: 20.w,
        color: _categoryColor(notification.category),
      ),
    );
  }

  static IconData _categoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.jobs:
        return Icons.work_outline;
      case NotificationCategory.payments:
        return Icons.payment_outlined;
      case NotificationCategory.rewards:
        return Icons.card_giftcard_outlined;
    }
  }

  static Color _categoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.jobs:
        return AppColors.primary;
      case NotificationCategory.payments:
        return const Color(0xFF16A34A); // Green
      case NotificationCategory.rewards:
        return const Color(0xFFEAB308); // Amber
    }
  }

  static String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}
