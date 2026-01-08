import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ReviewTile extends StatelessWidget {
  final String reviewerName;
  final String timeAgo;
  final double rating;
  final String comment;
  final String avatarUrl; // In real app

  const ReviewTile({
    super.key,
    required this.reviewerName,
    required this.timeAgo,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.neutral20,
                backgroundImage: AssetImage(avatarUrl), // Placeholder
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewerName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Startup for stars
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: index < rating.floor()
                            ? AppColors.starYellow
                            : AppColors.neutral30, // Simplified rating logic
                      );
                    }),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
