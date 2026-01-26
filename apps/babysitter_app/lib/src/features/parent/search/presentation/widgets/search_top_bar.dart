import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_ui_tokens.dart';
import '../providers/search_filter_provider.dart';

class SearchTopBar extends ConsumerStatefulWidget {
  const SearchTopBar({super.key});

  @override
  ConsumerState<SearchTopBar> createState() => _SearchTopBarState();
}

class _SearchTopBarState extends ConsumerState<SearchTopBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterController = ref.watch(searchFilterProvider);
    final searchText = filterController.value.searchQuery ?? '';

    // Only update controller text if it's different to avoid unnecessary updates
    if (_searchController.text != searchText) {
      _searchController.text = searchText;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

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
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: AppUiTokens.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      filterController.setSearchQuery(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search By Sitter Name or Location',
                      hintStyle: AppUiTokens.searchPlaceholder,
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
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
