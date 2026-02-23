import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/theme/home_design_tokens.dart';
import 'package:babysitter_app/src/features/notifications/presentation/providers/notification_providers.dart';

class HomeHeader extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
    final unreadCount = unreadCountAsync.value ?? 0;

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
                      size: 16,
                      color: AppColors.neutral30,
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

          // Notification Bell with Badge
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    size: 28,
                    color: AppColors.neutral60,
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                            minWidth: 16, minHeight: 16),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTypography.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
