import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
import '../widgets/profile_header_bar.dart';
import '../widgets/profile_summary_header.dart';
import '../widgets/profile_tabs.dart';
import '../widgets/bottom_booking_bar.dart';
import '../sections/overview_section.dart';
import '../sections/skills_section.dart';
import '../sections/availability_section.dart';
import '../sections/reviews_section.dart';

class SitterProfileView extends StatelessWidget {
  final SitterModel sitter;

  const SitterProfileView({super.key, required this.sitter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 100), // Space for sticky bottom bar
            child: Column(
              children: [
                // Top Section Background
                Container(
                    color: const Color(0xFFF0F9FF),
                    height: MediaQuery.of(context)
                        .padding
                        .top), // Status bar filler

                // Custom Header
                const ProfileHeaderBar(),

                // Hero Summary
                ProfileSummaryHeader(sitter: sitter),

                // Tabs (Sticky-ish visuals, but scrolls in this simple impl)
                const ProfileTabs(),

                // Sections
                OverviewSection(bio: sitter.bio),
                const Divider(
                    thickness: 8, color: Color(0xFFF9FAFB)), // Thick divider
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
            child: BottomBookingBar(price: sitter.hourlyRate),
          ),
        ],
      ),
    );
  }
}
