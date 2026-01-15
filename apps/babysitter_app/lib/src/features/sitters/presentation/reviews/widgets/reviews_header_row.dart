import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// Header row showing "Reviews" title and summary rating.
class ReviewsHeaderRow extends StatelessWidget {
  final double avgRating;
  final int totalReviews;

  const ReviewsHeaderRow({
    super.key,
    required this.avgRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Background matched to parent (white)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reviews',
            style: AppTokens.reviewsTitleStyle,
          ),
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 16.sp, // Slightly bigger than list stars usually, or same
                color: AppTokens.starFilledColor,
              ),
              SizedBox(width: 4.w),
              RichText(
                text: TextSpan(
                  text: '$avgRating ',
                  style: AppTokens.reviewsSummaryStyle.copyWith(
                    fontWeight: FontWeight.w600, // Make rating slightly bolder
                    color: const Color(0xFF1F2937), // Darker for number
                  ),
                  children: [
                    TextSpan(
                      text: '($totalReviews Reviews)',
                      style: AppTokens.reviewsSummaryStyle,
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
