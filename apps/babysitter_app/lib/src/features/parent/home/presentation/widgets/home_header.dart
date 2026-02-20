import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/home_design_tokens.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final String displayName;
  final String locationText;
  final String? avatarUrl;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
    required this.displayName,
    required this.locationText,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Top Header (light blue area handled by parent background)
    // Left: circular avatar image.
    // Title row: “Hi, Christie” (bold).
    // Under title: location row with pin icon + “Nashville, TN” (grey).
    // Right: bell/notification icon.

    final initials =
        displayName.isNotEmpty ? displayName.trim()[0].toUpperCase() : '?';
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: HomeDesignTokens.horizontalPadding, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(50),
              border: Border.all(color: Colors.white, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasAvatar
                ? (avatarUrl!.startsWith('http')
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral60,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral60,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      ))
                : Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral60,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Greeting & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $displayName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral60,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16, // Slightly bigger pin
                      color: AppColors.neutral30, // Lighter grey
                    ),
                    const SizedBox(width: 4),
                    Text(
                      locationText,
                      style: const TextStyle(
                        color: AppColors.neutral30,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notification Bell
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 28,
                color: AppColors.neutral60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
