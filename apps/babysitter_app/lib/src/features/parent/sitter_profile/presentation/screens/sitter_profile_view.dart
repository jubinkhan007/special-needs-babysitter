import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/overview_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/reviews_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/skills_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/bottom_booking_bar.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/experience_by_age_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/calendar_availability_section.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../../../../../routing/routes.dart';
import '../../../../messages/domain/chat_thread_args.dart';

class SitterProfileView extends StatefulWidget {
  final SitterModel sitter;
  final VoidCallback onBookPressed;
  final bool isBookmarked;
  final VoidCallback? onBookmark;

  const SitterProfileView({
    super.key,
    required this.sitter,
    required this.onBookPressed,
    this.isBookmarked = false,
    this.onBookmark,
  });

  @override
  State<SitterProfileView> createState() => _SitterProfileViewState();
}

class _SitterProfileViewState extends State<SitterProfileView> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;
  bool _isScrolling = false;

  // Global keys for each section
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _scheduleKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();

  // Tab labels
  final List<String> _tabs = ['Overview', 'Skills', 'Schedule', 'Reviews'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrolling) return; // Don't update during animated scroll

    final newIndex = _getCurrentSectionIndex();
    if (newIndex != _selectedTabIndex && mounted) {
      setState(() {
        _selectedTabIndex = newIndex;
      });
    }
  }

  int _getCurrentSectionIndex() {
    try {
      // Get scroll offset + sticky header height offset
      final scrollOffset = _scrollController.offset + 150; // Account for header + tabs

      final positions = <int, double>{};

      // Get positions for each section
      for (int i = 0; i < 4; i++) {
        final key = [_overviewKey, _skillsKey, _scheduleKey, _reviewsKey][i];
        final ctx = key.currentContext;
        if (ctx != null) {
          final box = ctx.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            // Get the position of this section relative to the scroll view
            final renderObject = box;
            final position = renderObject.localToGlobal(Offset.zero);
            // Convert to scroll coordinates
            positions[i] = _scrollController.offset + position.dy;
          }
        }
      }

      if (positions.isEmpty) return 0;

      // Find which section is currently at or just above the viewport
      // Start from the bottom and work up to find the active section
      for (int i = 3; i >= 0; i--) {
        if (positions.containsKey(i) && positions[i]! <= scrollOffset) {
          return i;
        }
      }
    } catch (e) {
      // Silently ignore errors during scroll
    }
    return 0;
  }

  void _onTabTap(int index) {
    setState(() {
      _selectedTabIndex = index;
      _isScrolling = true;
    });

    final keyMap = {
      0: _overviewKey,
      1: _skillsKey,
      2: _scheduleKey,
      3: _reviewsKey,
    };

    final targetKey = keyMap[index];
    if (targetKey?.currentContext != null) {
      final ctx = targetKey!.currentContext!;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final targetOffset = _scrollController.offset + position.dy - 110;
        _scrollController
            .animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
            .then((_) {
          if (mounted) {
            setState(() {
              _isScrolling = false;
            });
          }
        });
      } else {
        setState(() {
          _isScrolling = false;
        });
      }
    } else {
      setState(() {
        _isScrolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Profile Header (non-sticky)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SitterProfileHeaderExact(
                      name: widget.sitter.name,
                      distanceText: widget.sitter.location,
                      ratingText: widget.sitter.rating.toStringAsFixed(1),
                      avatarAsset: widget.sitter.avatarUrl,
                      isBookmarked: widget.isBookmarked,
                      onBookmark: widget.onBookmark,
                      onMessage: () {
                        final args = ChatThreadArgs(
                          otherUserId: widget.sitter.userId,
                          otherUserName: widget.sitter.name,
                          otherUserAvatarUrl: widget.sitter.avatarUrl,
                          isVerified: true,
                        );
                        context.push(
                          '/parent/messages/chat/${widget.sitter.userId}',
                          extra: args,
                        );
                      },
                      onTapRating: () {
                        context.push(
                          Uri(
                            path: Routes.sitterReviews,
                            queryParameters: {'id': widget.sitter.userId},
                          ).toString(),
                          extra: {'name': widget.sitter.name},
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Sticky Tabs - THIS IS THE KEY PART
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _StickyTabsDelegate(
                  tabs: _tabs,
                  selectedIndex: _selectedTabIndex,
                  onTabTap: _onTabTap,
                  topPadding: MediaQuery.of(context).padding.top,
                ),
              ),

              // Content Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Overview Section
                      Container(
                        key: _overviewKey,
                        child: OverviewSection(
                          bio: widget.sitter.bio,
                          willingToTravel: widget.sitter.willingToTravel,
                          travelRadius: widget.sitter.travelRadius,
                          hasTransportation: widget.sitter.hasTransportation,
                          transportationType: widget.sitter.transportationType,
                        ),
                      ),

                      const SizedBox(height: 12),
                      ExperienceByAgeSection(ageRanges: widget.sitter.ageRanges),
                      const SizedBox(height: 24),

                      // Travel Radius & Transport Availability
                      _buildTravelSection(),
                      const SizedBox(height: 24),

                      // Skills Section
                      Container(
                        key: _skillsKey,
                        child: SkillsSection(
                          languages: widget.sitter.languages,
                          certifications: widget.sitter.certifications,
                          skills: widget.sitter.badges,
                        ),
                      ),

                      // Calendar Availability (Schedule)
                      Container(
                        key: _scheduleKey,
                        child: CalendarAvailabilitySection(
                          availability: widget.sitter.availability,
                        ),
                      ),

                      // Reviews Section
                      Container(
                        key: _reviewsKey,
                        child: ReviewsSection(
                          reviews: widget.sitter.reviews,
                          averageRating: widget.sitter.rating,
                          totalReviews: widget.sitter.reviews.length,
                          onTapSeeAll: () {
                            context.push(
                              Uri(
                                path: Routes.sitterReviews,
                                queryParameters: {'id': widget.sitter.userId},
                              ).toString(),
                              extra: {'name': widget.sitter.name},
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

          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomBookingBar(
              price: widget.sitter.hourlyRate,
              onBookPressed: widget.onBookPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Travel Radius",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppUiTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.sitter.travelRadius ?? "Up to 15 km",
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppUiTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Transport Availability",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppUiTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.sitter.hasTransportation)
                          const Icon(Icons.check,
                              size: 16, color: AppUiTokens.textSecondary),
                        if (widget.sitter.hasTransportation)
                          const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.sitter.hasTransportation
                                ? (widget.sitter.transportationType ??
                                    "Owns vehicle")
                                : "No transport",
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppUiTokens.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sticky tabs delegate for SliverPersistentHeader
class _StickyTabsDelegate extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabTap;
  final double topPadding;

  _StickyTabsDelegate({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabTap,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50 + topPadding,
      padding: EdgeInsets.only(top: topPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppUiTokens.borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabTap(index),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 50,
                decoration: isSelected
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppUiTokens.primaryBlue,
                            width: 2,
                          ),
                        ),
                      )
                    : null,
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppUiTokens.textPrimary
                          : AppUiTokens.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  double get maxExtent => 50 + topPadding;

  @override
  double get minExtent => 50 + topPadding;

  @override
  bool shouldRebuild(covariant _StickyTabsDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.tabs != tabs ||
        oldDelegate.topPadding != topPadding;
  }
}
