import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import 'surface_card.dart';
import 'circular_progress_avatar.dart';

/// Profile card showing user avatar with progress ring, name, email, and View Profile link.
class AccountProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final double profileProgress;
  final VoidCallback? onViewProfile;

  const AccountProfileCard({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.profileProgress = 0.6,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with progress ring
          CircularProgressAvatar(
            imageUrl: avatarUrl,
            progress: profileProgress,
            size: AppTokens.progressAvatarSize,
          ),
          SizedBox(width: 16.w),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTokens.accountNameStyle,
                ),
                SizedBox(height: 4.h),
                Text(
                  email,
                  style: AppTokens.accountEmailStyle,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: onViewProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Profile Details',
                        style: AppTokens.accountLinkStyle,
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 16.sp,
                        color: AppTokens.accountLinkBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
