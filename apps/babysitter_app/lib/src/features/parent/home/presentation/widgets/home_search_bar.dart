import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/home_design_tokens.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Full-width rounded search container
    // Left search icon + placeholder “Search”
    // Border + subtle shadow exactly like screenshot

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 48, // Standard touch height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFECECEC),
          width: 1,
        ),
        boxShadow: HomeDesignTokens.defaultCardShadow, // Use common shadow
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary.withAlpha(150),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
