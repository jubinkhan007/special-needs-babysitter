import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header widget showing avatar, name, and status for call screens
class CallAvatarHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String statusText;
  final bool isVideo;

  const CallAvatarHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.statusText,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with glow effect
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isVideo ? Colors.blue : Colors.green).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.grey[700],
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 48.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(height: 24.h),

        // Name
        Text(
          name,
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),

        // Status with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (statusText.contains('Calling') || statusText.contains('Incoming'))
              _buildPulsingDot(),
            if (statusText.contains('Calling') || statusText.contains('Incoming'))
              SizedBox(width: 8.w),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: value),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {},
    );
  }
}
