import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/review.dart';
import 'models/review_ui_model.dart';
import 'widgets/reviews_header_row.dart';
import 'widgets/review_list_item.dart';

/// Screen displaying list of reviews for a sitter.
class ReviewsScreen extends StatelessWidget {
  final String sitterId;
  // These could come from args or fetched via ID, passing them for simplicity/mocking
  final String sitterName;
  final double avgRating;
  final int totalReviews;

  const ReviewsScreen({
    super.key,
    required this.sitterId,
    this.sitterName = 'Krystina', // Default/Mock if null
    this.avgRating = 4.5,
    this.totalReviews = 112,
  });

  @override
  Widget build(BuildContext context) {
    // Mock Data based on Screenshot
    final List<Review> reviews = [
      Review(
        id: '1',
        reviewerName: 'Ayesha K',
        rating: 5.0,
        comment:
            'Krystina connected so well with my daughter who has sensory needs. Her calm presence made all the difference.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=1', // Mock URL
      ),
      Review(
        id: '2',
        reviewerName: 'James W',
        rating: 5.0, // 5 stars in screenshot
        comment:
            'Krystina is reliable, friendly, and communicates clearly. My son always looks forward to seeing her!',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=2',
      ),
      Review(
        id: '3',
        reviewerName: 'Lina S',
        rating:
            4.0, // 4 stars shown (last empty) - wait, screenshot actually shows full stars for Ayesha and James. Let's vary it.
        // Actually screenshot items 3 (Lina S) has 5 stars.
        // Item 4 (David M) has 5 stars.
        // Item 5 (Reema T) has 4 stars (last empty).
        comment:
            'We hired Krystina for evening care and she instantly bonded with our 3-year-old son. Very warm, professional, and always on time.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=3',
      ),
      Review(
        id: '4',
        reviewerName: 'David M',
        rating: 5.0,
        comment:
            'I appreciate how Krystina handles my twins with autism. She uses visual aids and routines that actually work. Highly recommend for special needs care.',
        createdAt: DateTime.now().subtract(const Duration(days: 16)),
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=4',
      ),
      Review(
        id: '5',
        reviewerName: 'Reema T',
        rating: 4.0, // 4 stars in screenshot
        comment:
            'Krystina stepped in last minute when our regular sitter canceled. She kept us updated throughout the evening and left the house spotless.',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=5',
      ),
      Review(
        id: '6',
        reviewerName: 'Ayesha K',
        rating: 5.0,
        comment:
            'Krystina connected so well with my daughter who has sensory needs. Her calm presence made all the difference.',
        createdAt: DateTime.now()
            .subtract(const Duration(days: 2)), // Duplicated for scroll
        reviewerAvatarUrl: 'https://i.pravatar.cc/150?u=1',
      ),
    ];

    final uiModels = reviews.map((r) => ReviewUiModel(r)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTokens.reviewsHeaderBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '$sitterName Review',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.appBarTitleColor,
          ),
        ),
      ),
      body: MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.0,
        child: CustomScrollView(
          slivers: [
            // Header Row (pinned or scrolling? Screenshot implies standard scroll)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.savedSittersHPad
                    .w, // Using savedSittersHPad (20) or screenHorizontal (24)?
                // Creating a specific alias is better if "screenHorizontalPadding" isn't generic.
                // Reusing shared padding. Let's use 24.w from screenTokens if available or fallback.
                // SavedSitters uses 20. Account uses 24.
                // Let's use 20.0 (savedSittersHPad) as it looks similar, or define generic.
              ),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 16.h), // Some top padding for header
                  child: ReviewsHeaderRow(
                    avgRating: avgRating,
                    totalReviews: totalReviews,
                  ),
                ),
              ),
            ),

            // List
            SliverPadding(
              padding: EdgeInsets.only(
                top: AppTokens.reviewsTopSpacing.h,
                left: AppTokens.savedSittersHPad.w,
                right: AppTokens.savedSittersHPad.w,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ReviewListItem(model: uiModels[index]);
                  },
                  childCount: uiModels.length,
                ),
              ),
            ),

            // Bottom Spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 32.h),
            ),
          ],
        ),
      ),
    );
  }
}
