import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

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
        ],
      ),
    );
  }
}
