import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_ui_tokens.dart';
import '../widgets/search_top_bar.dart';
import '../widgets/filter_row.dart';
import '../widgets/sitter_card.dart';
import '../../../../../routing/routes.dart';

import '../filter/controller/search_filter_controller.dart';
import '../filter/filter_bottom_sheet.dart';
import '../providers/sitters_list_provider.dart';

class SitterSearchResultsScreen extends ConsumerStatefulWidget {
  const SitterSearchResultsScreen({super.key});

  @override
  ConsumerState<SitterSearchResultsScreen> createState() =>
      _SitterSearchResultsScreenState();
}

class _SitterSearchResultsScreenState
    extends ConsumerState<SitterSearchResultsScreen> {
  final SearchFilterController _filterController = SearchFilterController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider
    final asyncSitters = ref.watch(sittersListProvider);

    // Using standard standard density to avoid spacing shifts
    return Theme(
      data: Theme.of(context).copyWith(visualDensity: VisualDensity.standard),
      child: Scaffold(
        backgroundColor: AppUiTokens.scaffoldBackground,
        body: Column(
          children: [
            // Top Bar (Blue background)
            const SearchTopBar(),

            // Content
            Expanded(
              child: asyncSitters.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error loading sitters: $error'),
                ),
                data: (sitters) => Column(
                  children: [
                    // Filter Row (White background)
                    FilterRow(
                      count: sitters.length,
                      onFilterTap: () {
                        FilterBottomSheet.show(context, _filterController);
                      },
                    ),

                    // List of Cards
                    Expanded(
                      child: sitters.isEmpty
                          ? const Center(child: Text("No sitters found."))
                          : ListView.separated(
                              padding: EdgeInsets.only(
                                top: AppUiTokens.itemSpacing,
                                bottom: MediaQuery.of(context).padding.bottom +
                                    16, // Safe area + spacing
                              ),
                              itemCount: sitters.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: AppUiTokens.itemSpacing),
                              itemBuilder: (context, index) {
                                final sitter = sitters[index];
                                return SitterCard(
                                  sitter: sitter,
                                  onTap: () {
                                    // Navigate to profile using the ID
                                    context.push(
                                        Routes.sitterProfilePath(sitter.id));
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
