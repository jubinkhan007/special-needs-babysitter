import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/theme/home_design_tokens.dart';

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F9FF), // Light blue tint
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
            // Title
            const Text(
              'Krystina Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            // Actions
            Row(
              children: const [
                Icon(Icons.bookmark_border, color: AppColors.textPrimary),
                SizedBox(width: 16),
                Icon(Icons.share_outlined, color: AppColors.textPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
