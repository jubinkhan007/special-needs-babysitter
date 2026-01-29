import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/sitter_review.dart';
import '../providers/sitter_reviews_providers.dart';

class SitterReviewsScreen extends ConsumerWidget {
  const SitterReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(sitterReviewsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Text(
          'My Reviews',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                'No reviews yet.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                ),
              ),
            );
          }
          
          // Calculate average rating and total reviews
          final totalReviews = reviews.length;
          final avgRating = reviews.isNotEmpty
              ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews
              : 0.0;
          
          return CustomScrollView(
            slivers: [
              // Header Row with Reviews title and rating summary
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    child: _ReviewsHeaderRow(
                      avgRating: avgRating,
                      totalReviews: totalReviews,
                    ),
                  ),
                ),
              ),
              // Reviews List
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final review = reviews[index];
                      return Column(
                        children: [
                          _ReviewCard(review: review),
                          if (index < reviews.length - 1)
                            Divider(
                              height: 24.h,
                              thickness: 1,
                              color: const Color(0xFFF2F4F7),
                            ),
                        ],
                      );
                    },
                    childCount: reviews.length,
                  ),
                ),
              ),
              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 32.h),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Failed to load reviews',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}

/// Header row showing "Reviews" title and summary rating
class _ReviewsHeaderRow extends StatelessWidget {
  final double avgRating;
  final int totalReviews;

  const _ReviewsHeaderRow({
    required this.avgRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 16.sp,
              color: const Color(0xFFFBBF24),
            ),
            SizedBox(width: 4.w),
            RichText(
              text: TextSpan(
                text: '${avgRating.toStringAsFixed(1)} ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                children: [
                  TextSpan(
                    text: '($totalReviews Reviews)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final SitterReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final reviewerName =
        review.reviewerName.isNotEmpty ? review.reviewerName : _reviewerLabel(review);
    final timeAgo = _timeAgo(review.createdAt);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        _ReviewAvatar(
          imageUrl: _getAvatarUrl(review),
        ),
        SizedBox(width: 12.w),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Time Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reviewerName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              // Star Rating Row
              _StarRow(rating: review.rating),
              SizedBox(height: 8.h),
              // Comment
              Text(
                review.reviewText,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: const Color(0xFF4B5563),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A row of stars representing a rating
class _StarRow extends StatelessWidget {
  final double rating;

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Icon(
            Icons.star_rounded,
            size: 14.sp,
            color: isFilled ? const Color(0xFFFBBF24) : const Color(0xFFE5E7EB),
          ),
        );
      }),
    );
  }
}

class _ReviewAvatar extends StatelessWidget {
  final String? imageUrl;

  const _ReviewAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final trimmed = imageUrl?.trim() ?? '';
    if (trimmed.isNotEmpty && trimmed.startsWith('http')) {
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(trimmed),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE5E7EB),
      ),
      child: Icon(Icons.person, size: 20.sp, color: Colors.white),
    );
  }
}

String? _getAvatarUrl(SitterReview review) {
  final avatar = review.reviewerAvatar;
  if (avatar.isNotEmpty) {
    return avatar;
  }
  final imageUrl = review.imageUrl;
  if (imageUrl.isNotEmpty) {
    return imageUrl;
  }
  return null;
}

String _reviewerLabel(SitterReview review) {
  final role = review.reviewerRole.trim();
  if (role.isEmpty) {
    return 'Parent';
  }
  return role[0].toUpperCase() + role.substring(1);
}

String _timeAgo(DateTime? createdAt) {
  if (createdAt == null) return '';
  final now = DateTime.now();
  final difference = now.difference(createdAt);
  if (difference.inDays > 0) {
    return '${difference.inDays} Days Ago';
  }
  if (difference.inHours > 0) {
    return '${difference.inHours} Hours Ago';
  }
  return 'Just Now';
}
