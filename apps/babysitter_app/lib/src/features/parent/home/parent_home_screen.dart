import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/models/home_mock_models.dart';
import 'presentation/theme/home_design_tokens.dart';
import 'presentation/widgets/active_booking_card.dart';
import 'presentation/widgets/complete_profile_card.dart';
import 'presentation/widgets/home_header.dart';
import 'presentation/widgets/home_search_bar.dart';
import 'presentation/widgets/promo_banner_card.dart';
import 'presentation/widgets/saved_sitter_card.dart';
import 'presentation/widgets/sitter_near_you_card.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light grey bg
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onNotificationTap: () {},
              ),
              const SizedBox(height: HomeDesignTokens.headerBottomSpacing),
              const HomeSearchBar(),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              const PromoBannerCard(),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              ActiveBookingCard(booking: HomeMockData.activeBooking),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              _buildSectionHeader('Sitters Near You', onSeeAll: () {}),
              const SizedBox(height: HomeDesignTokens.itemSpacing),
              SizedBox(
                height: HomeDesignTokens
                    .sitterNearYouHeight, // Fixed height for cards
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none, // Allow shadow overflow
                  itemCount: HomeMockData.sittersNearYou.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final sitter = HomeMockData.sittersNearYou[index];
                    return SitterNearYouCard(sitter: sitter);
                  },
                ),
              ),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              _buildSectionHeader('Saved Sitters', onSeeAll: () {}),
              const SizedBox(height: HomeDesignTokens.itemSpacing),
              SizedBox(
                height: HomeDesignTokens.savedSitterHeight,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: HomeMockData.savedSitters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final sitter = HomeMockData.savedSitters[index];
                    return SavedSitterCard(sitter: sitter);
                  },
                ),
              ),
              const CompleteProfileCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: HomeDesignTokens.sectionHeader,
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: HomeDesignTokens.seeAllText,
              ),
            ),
        ],
      ),
    );
  }
}
