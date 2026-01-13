import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../widgets/age_experience_item.dart';

class OverviewSection extends StatelessWidget {
  final String bio;

  const OverviewSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview
          const Text(
            "Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            bio,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppUiTokens.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // Experience By Age
          const Text(
            "Experience By Age",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AgeExperienceItem(label: "Infants", icon: Icons.child_care),
              AgeExperienceItem(
                  label: "Toddlers", icon: Icons.baby_changing_station),
              AgeExperienceItem(
                  label: "Children",
                  icon: Icons.face), // Using face as placeholder for Children
              AgeExperienceItem(
                  label: "Teens", icon: Icons.people), // Groups for teens
            ],
          ),
          const SizedBox(height: 32),

          // Travel Radius & Transport
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
                    const Text(
                      "Up to 15 km",
                      style: TextStyle(
                          fontSize: 15, color: AppUiTokens.textSecondary),
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
                      children: const [
                        Icon(Icons.check,
                            size: 16, color: AppUiTokens.textPrimary),
                        SizedBox(width: 6),
                        Text(
                          "Owns vehicle",
                          style: TextStyle(
                              fontSize: 15, color: AppUiTokens.textSecondary),
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
    );
  }
}
