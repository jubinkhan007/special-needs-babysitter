import 'package:flutter/material.dart';
import '../theme/app_ui_tokens.dart';

class SearchTopBar extends StatelessWidget {
  const SearchTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppUiTokens.topBarBackground,
      padding: EdgeInsets.fromLTRB(
        AppUiTokens.horizontalPadding,
        MediaQuery.of(context).padding.top + 8, // Status bar + spacing
        AppUiTokens.horizontalPadding,
        16, // Bottom spacing
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Back, Title, Bell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: AppUiTokens.textPrimary,
                ),
              ),
              // Title
              const Text(
                'Search',
                style: AppUiTokens.appBarTitle,
              ),
              // Bell Icon
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 24,
                  color: AppUiTokens.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Search Field
          Container(
            height: AppUiTokens.searchBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppUiTokens.radiusMedium),
              border: Border.all(color: AppUiTokens.borderColor),
              // Optional subtle shadow if desired, but spec said "Rounded rectangle with white background... Use subtle border/shadow if present"
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: AppUiTokens.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Search By Sitter Name or Location',
                    style: AppUiTokens.searchPlaceholder,
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
