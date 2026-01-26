import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/overview_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/reviews_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/skills_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/bottom_booking_bar.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/profile_header.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/experience_by_age_section.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/sections/calendar_availability_section.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../../../../../routing/routes.dart';
import '../../../../messages/domain/chat_thread_args.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ Use the new pixel-perfect header here

                SizedBox(
                  height: 10,
                ),

                SitterProfileHeaderExact(
                  name: sitter.name,
                  distanceText: sitter.location, // Dynamic location/distance
                  ratingText: sitter.rating.toStringAsFixed(1),
                  avatarAsset: sitter.avatarUrl, // asset path
                  onMessage: () {
                    final args = ChatThreadArgs(
                      otherUserId: sitter.id,
                      otherUserName: sitter.name,
                      otherUserAvatarUrl: sitter.avatarUrl,
                      isVerified: true, // Assume verified for now
                    );
                    context.push(
                      '/parent/messages/chat/${sitter.id}',
                      extra: args,
                    );
                  },
                  onTapRating: () {
                    context.push(
                      Uri(
                        path: Routes.sitterReviews,
                        queryParameters: {'id': sitter.id},
                      ).toString(),
                      extra: {'name': sitter.name},
                    );
                  },
                ),

                // Tabs
                const ProfileTabs(),

                // Sections
                OverviewSection(
                  bio: sitter.bio,
                  willingToTravel: sitter.willingToTravel,
                  travelRadius: sitter.travelRadius,
                  hasTransportation: sitter.hasTransportation,
                  transportationType: sitter.transportationType,
                ),

                const SizedBox(height: 12),
                ExperienceByAgeSection(ageRanges: sitter.ageRanges),
                const SizedBox(height: 24),

                // Travel Radius & Transport Availability
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Travel Radius",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppUiTokens.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  sitter.travelRadius ?? "Up to 15 km",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: AppUiTokens.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Transport Availability",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppUiTokens.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (sitter.hasTransportation)
                                      const Icon(Icons.check,
                                          size: 16,
                                          color: AppUiTokens.textSecondary),
                                    if (sitter.hasTransportation)
                                      const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        sitter.hasTransportation
                                            ? (sitter.transportationType ??
                                                "Owns vehicle")
                                            : "No transport",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: AppUiTokens.textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SkillsSection(
                  languages: sitter.languages,
                  certifications: sitter.certifications,
                  skills: sitter.badges,
                ),
                // Calendar Availability
                CalendarAvailabilitySection(availability: sitter.availability),
                ReviewsSection(
                  reviews: sitter.reviews,
                  averageRating: sitter.rating,
                  totalReviews: sitter.reviews
                      .length, // Or use a field if count differs from list length
                  onTapSeeAll: () {
                    context.push(
                      Uri(
                        path: Routes.sitterReviews,
                        queryParameters: {'id': sitter.id},
                      ).toString(),
                      extra: {'name': sitter.name},
                    );
                  },
                ),
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
