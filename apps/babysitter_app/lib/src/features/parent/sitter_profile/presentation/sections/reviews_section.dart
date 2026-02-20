import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../../../home/presentation/models/home_mock_models.dart';

class ReviewsSection extends StatelessWidget {
  final VoidCallback? onTapSeeAll;
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalReviews;
  final int maxReviewsToShow;

  const ReviewsSection({
    super.key,
    this.onTapSeeAll,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.maxReviewsToShow = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Limit reviews to show
    final reviewsToShow = reviews.take(maxReviewsToShow).toList();
    final hasMoreReviews = reviews.length > maxReviewsToShow;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppUiTokens.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: onTapSeeAll,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppUiTokens.starYellow, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppUiTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "($totalReviews Reviews)",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppUiTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        size: 20, color: AppUiTokens.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic List
          if (reviews.isEmpty)
            const Text(
              "No reviews yet.",
              style: TextStyle(color: AppUiTokens.textSecondary),
            )
          else
            ...List.generate(reviewsToShow.length, (index) {
              final review = reviewsToShow[index];
              return Column(
                children: [
                  _buildReviewItem(
                    name: review.authorName,
                    date: _formatDate(review.date),
                    rating: review.rating,
                    comment: review.comment,
                    imageAsset: review.authorAvatarUrl,
                  ),
                  if (index < reviewsToShow.length - 1 || hasMoreReviews) _buildDivider(),
                ],
              );
            }),

          // See All button when there are more reviews
          if (hasMoreReviews)
            GestureDetector(
              onTap: onTapSeeAll,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "See All Reviews",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppUiTokens.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppUiTokens.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),

          if (reviews.isNotEmpty)
            const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple logic for "X days ago" or just format
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return "${diff.inDays} Days Ago";
    }
    return "Today";
  }

  Widget _buildReviewItem({
    required String name,
    required String date,
    required double rating,
    required String comment,
    required String imageAsset,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2F4F7), // Placeholder bg
            ),
            child: ClipOval(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppUiTokens.textPrimary,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppUiTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Stars
                Row(
                  children: List.generate(5, (index) {
                    // Simple logic: index < rating ? filled : empty
                    // Handling .5?
                    // For now simple filled/empty.
                    bool isWhole = index < rating;
                    return Icon(
                      isWhole ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppUiTokens.starYellow,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: AppUiTokens
                        .textPrimary, // Or secondary? Design looks dark grey
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF2F4F7),
    );
  }
}
