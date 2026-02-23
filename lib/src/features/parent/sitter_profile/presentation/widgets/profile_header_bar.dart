import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 8, // iOS standardish, but Figma shows good spacing.
        right: 16,
      ),
      height:
          MediaQuery.of(context).padding.top + 44, // Standard nav bar height
      // No color, transparent
      child: NavigationToolbar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppUiTokens.textPrimary, size: 24),
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(), // minimize padding
        ),
        middle: const Text(
          'Krystina Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppUiTokens.textPrimary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.bookmark_border,
                  color: AppUiTokens.textPrimary, size: 24),
              onPressed: () {},
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 20), // Spacing between icons
            IconButton(
              icon: const Icon(Icons.share_outlined,
                  color: AppUiTokens.textPrimary, size: 24),
              onPressed: () {},
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        centerMiddle: true,
      ),
    );
  }
}
