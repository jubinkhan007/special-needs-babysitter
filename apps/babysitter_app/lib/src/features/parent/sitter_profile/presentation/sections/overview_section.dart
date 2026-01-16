import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../widgets/age_experience_item.dart';

class OverviewSection extends StatelessWidget {
  final String bio;
  final bool willingToTravel;
  final String? travelRadius;
  final bool hasTransportation;
  final String? transportationType;

  const OverviewSection({
    super.key,
    required this.bio,
    required this.willingToTravel,
    this.travelRadius,
    required this.hasTransportation,
    this.transportationType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ... (lines 16-64 unchanged)
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

          // Experience By Age (Keep hardcoded for now or update if SitterModel has it)
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
                    Text(
                      travelRadius ?? "N/A",
                      style: const TextStyle(
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
                      children: [
                        if (hasTransportation)
                          const Icon(Icons.check,
                              size: 16, color: AppUiTokens.textPrimary),
                        if (hasTransportation) const SizedBox(width: 6),
                        Text(
                          hasTransportation
                              ? (transportationType ?? "Owns vehicle")
                              : "No transport",
                          style: const TextStyle(
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
