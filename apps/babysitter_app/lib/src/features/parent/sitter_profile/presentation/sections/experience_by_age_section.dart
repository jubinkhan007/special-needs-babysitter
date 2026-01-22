import 'package:flutter/material.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart';

class ExperienceByAgeSection extends StatelessWidget {
  final List<String> ageRanges;

  const ExperienceByAgeSection({super.key, required this.ageRanges});

  @override
  Widget build(BuildContext context) {
    // Normalize user data for comparison
    final normalizedRanges =
        ageRanges.map((e) => e.toLowerCase().trim()).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            children: [
              _buildAgeItem("Infants", Icons.child_care, normalizedRanges),
              _buildAgeItem(
                  "Toddlers", Icons.baby_changing_station, normalizedRanges),
              _buildAgeItem(
                  "Children", Icons.escalator_warning, normalizedRanges),
              _buildAgeItem("Teens", Icons.face, normalizedRanges),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeItem(
      String label, IconData icon, List<String> normalizedRanges) {
    // Check if this age group is in the list
    // "infants", "toddlers", "children" (usually school-age), "teens"
    final key = label.toLowerCase();

    // Some fuzzy matching might be needed depending on API values
    // API returns: "infants", "toddlers", "preschool", "school_age", "teenager" usually?
    // Let's assume strict match or simple contains.
    // The user JSON showed: "infants", "toddlers".

    // We check if any of the user ranges contains our key or equals it.
    bool isActive = normalizedRanges.any((range) => range.contains(key));

    final color = isActive ? AppUiTokens.verifiedBlue : const Color(0xFFD0D5DD);
    final textColor =
        isActive ? AppUiTokens.textPrimary : const Color(0xFF98A2B3);

    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
