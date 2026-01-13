import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: const [
                  Icon(Icons.star_rounded,
                      color: AppUiTokens.starYellow, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "4.5",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppUiTokens.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "(112 Reviews)", // Figma color check? Usually lighter
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppUiTokens.textSecondary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right,
                      size: 20, color: AppUiTokens.textSecondary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // List
          _buildReviewItem(
            name: "Ayesha K",
            date: "2 Days Ago",
            rating: 5,
            comment:
                "Krystina communicates well with my daughter who is non verbal. Her calm presence made all the difference.",
            imageAsset:
                "apps/babysitter_app/assets/images/reviewer/Ayesha_reviewer.png",
          ),
          _buildDivider(),
          _buildReviewItem(
            name: "James W",
            date: "10 Days Ago",
            rating: 4,
            comment:
                "Krystina is reliable, friendly, and communicates clearly. My son always looks forward to seeing her!",
            imageAsset:
                "apps/babysitter_app/assets/images/reviewer/james_reviewer.png",
          ),
          _buildDivider(),
          _buildReviewItem(
            name: "Lina S",
            date: "15 Days Ago",
            rating: 5,
            comment:
                "We hired Krystina for evening care and she made the process seamless. Punctual, professional, and stays calm.",
            imageAsset:
                "apps/babysitter_app/assets/images/reviewer/lina_reviewer.png",
          ),
          _buildDivider(),
          _buildReviewItem(
            name: "David M",
            date: "10 Days Ago",
            rating: 5,
            comment:
                "Experience with Krystina has been great! She sets routines that actually work. Highly recommend.",
            imageAsset:
                "apps/babysitter_app/assets/images/reviewer/james_reviewer.png", // Reuse
          ),
          _buildDivider(),
          _buildReviewItem(
            name: "Reema T",
            date: "20 Days Ago",
            rating: 5,
            comment:
                "Krystina stepped in last minute when our regular sitter canceled. She kept us updated throughout. Amazing and so professional.",
            imageAsset:
                "apps/babysitter_app/assets/images/reviewer/Ayesha_reviewer.png", // Reuse
          ),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
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
                errorBuilder: (_, __, ___) =>
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
