import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/review.dart';
import 'models/review_ui_model.dart';
import 'providers/reviews_provider.dart';
import 'widgets/reviews_header_row.dart';
import 'widgets/review_list_item.dart';

/// Screen displaying list of reviews for a sitter.
class ReviewsScreen extends ConsumerWidget {
  final String sitterId;
  final String sitterName;

  const ReviewsScreen({
    super.key,
    required this.sitterId,
    required this.sitterName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(sitterReviewsProvider(sitterId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTokens.reviewsHeaderBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
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
        child: reviewsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              'Failed to load reviews: $err',
              style: TextStyle(
                fontFamily: AppTokens.fontFamily,
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
          data: (reviews) => _buildContent(reviews),
        ),
      ),
    );
  }

  Widget _buildContent(List<Review> reviews) {
    // Calculate average rating and total reviews
    final totalReviews = reviews.length;
    final avgRating = reviews.isNotEmpty
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews
        : 0.0;

    final uiModels = reviews.map((r) => ReviewUiModel(r)).toList();

    return CustomScrollView(
      slivers: [
        // Header Row with Reviews title and rating summary
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTokens.savedSittersHPad.w,
          ),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
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
    );
  }
}
