import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/theme/home_design_tokens.dart';
import '../widgets/review_tile.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.star_rounded,
                      color: AppColors.starYellow, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "4.5 (112 Reviews)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right,
                      size: 18, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // List
          ReviewTile(
            reviewerName: "Ayesha K",
            timeAgo: "2 Days Ago",
            rating: 5,
            comment:
                "Krystina communicates well with my daughter who is non verbal. Her calm presence made all the difference.",
            avatarUrl: "assets/images/user1.png", // Mock
          ),
          const Divider(height: 1, color: AppColors.neutral20),
          ReviewTile(
            reviewerName: "James W",
            timeAgo: "10 Days Ago",
            rating: 4.5,
            comment:
                "Krystina is reliable, friendly, and communicates clearly. My son always looks forward to seeing her!",
            avatarUrl: "assets/images/user2.png", // Mock
          ),
          const Divider(height: 1, color: AppColors.neutral20),
          ReviewTile(
            reviewerName: "Lina S",
            timeAgo: "15 Days Ago",
            rating: 5,
            comment:
                "We hired Krystina for evening care and she made the process seamless. Punctual, professional, and stays calm.",
            avatarUrl: "assets/images/user3.png", // Mock
          ),
          const Divider(height: 1, color: AppColors.neutral20),
          ReviewTile(
            reviewerName: "David M",
            timeAgo: "18 Days Ago",
            rating: 5,
            comment:
                "Experience with Krystina has been great! She sets routines that actually work. Highly recommend.",
            avatarUrl: "assets/images/user4.png", // Mock
          ),
          // Add spacing at bottom
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
