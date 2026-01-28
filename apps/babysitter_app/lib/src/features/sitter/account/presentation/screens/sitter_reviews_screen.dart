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
          'My reviews',
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
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => Divider(
              height: 24.h,
              thickness: 1,
              color: const Color(0xFFF2F4F7),
            ),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _ReviewCard(review: review);
            },
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

class _ReviewCard extends StatelessWidget {
  final SitterReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final reviewerName = _reviewerLabel(review);
    final ratingText = review.rating.toStringAsFixed(1);
    final timeAgo = _timeAgo(review.createdAt);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewAvatar(imageUrl: review.imageUrl),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(width: 8.w),
                  Icon(Icons.star,
                      size: 14.sp, color: const Color(0xFFFBBF24)),
                  SizedBox(width: 4.w),
                  Text(
                    ratingText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF98A2B3),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                review.reviewText,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  color: const Color(0xFF667085),
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

class _ReviewAvatar extends StatelessWidget {
  final String imageUrl;

  const _ReviewAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final trimmed = imageUrl.trim();
    if (trimmed.isNotEmpty && trimmed.startsWith('http')) {
      return CircleAvatar(
        radius: 20.r,
        backgroundImage: NetworkImage(trimmed),
        backgroundColor: const Color(0xFFEFF4FF),
      );
    }
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: const Color(0xFFEFF4FF),
      child: Icon(Icons.person, size: 18.sp, color: const Color(0xFF98A2B3)),
    );
  }
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
