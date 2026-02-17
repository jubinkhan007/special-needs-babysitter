import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../../../routing/routes.dart';
import 'saved_sitters_controller.dart';
import 'widgets/saved_search_bar.dart';
import 'widgets/saved_list_header_row.dart';
import 'widgets/saved_sitter_card.dart';

/// The Saved Sitters screen displaying bookmarked sitters.
class SavedSittersScreen extends ConsumerStatefulWidget {
  const SavedSittersScreen({super.key});

  @override
  ConsumerState<SavedSittersScreen> createState() => _SavedSittersScreenState();
}

class _SavedSittersScreenState extends ConsumerState<SavedSittersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedSittersAsync = ref.watch(savedSittersControllerProvider);

    return Scaffold(
      backgroundColor: AppTokens.savedSittersBodyBg,
      appBar: AppBar(
        backgroundColor: AppTokens.savedSittersHeaderBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Saved Sitters',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.appBarTitleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTokens.appBarTitleColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.0,
        child: savedSittersAsync.when(
          data: (sitters) {
            // Apply local search filter if needed
            // For now, simple list
            return CustomScrollView(
              slivers: [
                // Search bar area
                SliverToBoxAdapter(
                  child: Container(
                    color: AppTokens.savedSittersHeaderBg,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTokens.savedSittersHPad.w,
                      vertical: 12.h,
                    ),
                    child: SavedSearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        // TODO: Local filtering logic
                      },
                    ),
                  ),
                ),

                // List header row
                SliverToBoxAdapter(
                  child: SavedListHeaderRow(
                    sitterCount: sitters.length,
                    onFilterTap: () {
                      // Open filter bottom sheet
                    },
                  ),
                ),

                // Sitter cards
                if (sitters.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No saved sitters yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTokens.savedSittersHPad.w,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final sitter = sitters[index];
                          return SavedSitterCard(
                            sitter: sitter,
                            isBookmarked: true, // Always true in saved list
                            onViewProfile: () {
                              // Use sitter.id (sitter profile ID) not sitter.userId
                              context.push(Routes.sitterProfilePath(sitter.id));
                            },
                            onBookmarkTap: () async {
                              final success = await ref
                                  .read(savedSittersControllerProvider.notifier)
                                  .removeBookmark(sitter.userId);
                              if (context.mounted && !success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to remove sitter'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        childCount: sitters.length,
                      ),
                    ),
                  ),

                // Bottom padding
                SliverToBoxAdapter(
                  child: SizedBox(height: 32.h),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading saved sitters: $error'),
          ),
        ),
      ),
    );
  }
}
