import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../../../routing/routes.dart';
import '../../domain/saved/saved_sitter.dart';
import 'models/saved_sitter_ui_model.dart';
import 'widgets/saved_search_bar.dart';
import 'widgets/saved_list_header_row.dart';
import 'widgets/saved_sitter_card.dart';

/// The Saved Sitters screen displaying bookmarked sitters.
class SavedSittersScreen extends StatefulWidget {
  const SavedSittersScreen({super.key});

  @override
  State<SavedSittersScreen> createState() => _SavedSittersScreenState();
}

class _SavedSittersScreenState extends State<SavedSittersScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data
  final List<SavedSitter> _savedSitters = const [
    SavedSitter(
      id: '1',
      name: 'Krystina',
      isVerified: true,
      rating: 4.5,
      location: 'Nashville, TN',
      responseRate: 95,
      reliabilityRate: 95,
      experienceYears: 5,
      hourlyRate: 20,
      skills: ['CPR', 'First-aid', 'Special Needs Training'],
      avatarUrl: '',
      isBookmarked: true,
    ),
    SavedSitter(
      id: '2',
      name: 'Krystina',
      isVerified: true,
      rating: 4.5,
      location: 'Nashville, TN',
      responseRate: 95,
      reliabilityRate: 95,
      experienceYears: 5,
      hourlyRate: 20,
      skills: ['CPR', 'First-aid', 'Special Needs Training'],
      avatarUrl: '',
      isBookmarked: true,
    ),
    SavedSitter(
      id: '3',
      name: 'Krystina',
      isVerified: true,
      rating: 4.5,
      location: 'Nashville, TN',
      responseRate: 95,
      reliabilityRate: 95,
      experienceYears: 5,
      hourlyRate: 20,
      skills: ['CPR', 'First-aid', 'Special Needs Training'],
      avatarUrl: '',
      isBookmarked: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiModels = _savedSitters.map((s) => SavedSitterUiModel(s)).toList();

    return Scaffold(
      backgroundColor: AppTokens.savedSittersBodyBg,
      appBar: AppBar(
        backgroundColor: AppTokens.savedSittersHeaderBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
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
            icon: Icon(
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
        child: CustomScrollView(
          slivers: [
            // Search bar area (pale blue background)
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
                    // Filter logic would go here
                  },
                ),
              ),
            ),

            // List header row
            SliverToBoxAdapter(
              child: SavedListHeaderRow(
                sitterCount: uiModels.length,
                onFilterTap: () {
                  // Open filter bottom sheet
                },
              ),
            ),

            // Sitter cards
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.savedSittersHPad.w,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final sitter = uiModels[index];
                    return SavedSitterCard(
                      sitter: sitter,
                      onViewProfile: () {
                        context.push(Routes.sitterProfilePath(sitter.id));
                      },
                      onBookmarkTap: () {
                        // Toggle bookmark
                      },
                    );
                  },
                  childCount: uiModels.length,
                ),
              ),
            ),

            // Bottom padding
            SliverToBoxAdapter(
              child: SizedBox(height: 32.h),
            ),
          ],
        ),
      ),
    );
  }
}
