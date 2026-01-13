import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/availability_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/overview_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/reviews_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/skills_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/bottom_booking_bar.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/profile_header.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';

class SitterProfileView extends StatelessWidget {
  final SitterModel sitter;
  final VoidCallback onBookPressed;

  const SitterProfileView({
    super.key,
    required this.sitter,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // ✅ Use the new pixel-perfect header here

                SizedBox(
                  height: 10,
                ),

                SitterProfileHeaderExact(
                  name: sitter.name,
                  distanceText: "2 Miles Away", // adjust if you have
                  ratingText: sitter.rating.toStringAsFixed(1),
                  avatarAsset: sitter.avatarUrl, // asset path
                  onMessage: () {
                    // TODO: navigate to chat screen
                  },
                ),

                // Tabs
                const ProfileTabs(),

                // Sections
                OverviewSection(bio: sitter.bio),
                const Divider(thickness: 8, color: Color(0xFFF9FAFB)),
                const SkillsSection(),
                const Divider(thickness: 8, color: Color(0xFFF9FAFB)),
                const AvailabilitySection(),
                const Divider(thickness: 8, color: Color(0xFFF9FAFB)),
                const ReviewsSection(),
              ],
            ),
          ),

          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomBookingBar(
              price: sitter.hourlyRate,
              onBookPressed: onBookPressed,
            ),
          ),
        ],
      ),
    );
  }
}
