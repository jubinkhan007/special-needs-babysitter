import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../models/home_mock_models.dart';
import '../theme/home_design_tokens.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({super.key, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    // Top Header (light blue area handled by parent background)
    // Left: circular avatar image.
    // Title row: “Hi, Christie” (bold).
    // Under title: location row with pin icon + “Nashville, TN” (grey).
    // Right: bell/notification icon.

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
            child: Image.asset(
              HomeMockData.currentUser.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${HomeMockData.currentUser.name}',
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
                    Icon(
                      Icons.location_on_outlined,
                      size: 16, // Slightly bigger pin
                      color: AppColors.neutral30, // Lighter grey
                    ),
                    const SizedBox(width: 4),
                    Text(
                      HomeMockData.currentUser.location,
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
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 28,
              color: AppColors.neutral60,
            ),
          ),
        ],
      ),
    );
  }
}
