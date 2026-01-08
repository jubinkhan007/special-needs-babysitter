import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../widgets/chip_pill.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Languages
          const Text(
            "Languages",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLanguageItem("English"),
              _buildDivider(),
              _buildLanguageItem("Spanish"),
              _buildDivider(),
              _buildLanguageItem("French"),
              _buildDivider(),
              _buildLanguageItem("Mandarin"),
            ],
          ),
          const SizedBox(height: 24),

          // Certifications
          const Text(
            "Certifications",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              ChipPill(
                  label: "CPR & First Aid",
                  icon: Icons.verified_user,
                  backgroundColor: Color(0xFF1B2A3B),
                  textColor: Colors.white),
              ChipPill(
                  label: "Special Needs Childcare",
                  icon: Icons.verified_user,
                  backgroundColor: Color(0xFF1B2A3B),
                  textColor: Colors.white),
              ChipPill(
                  label: "Infant Care",
                  icon: Icons.verified_user,
                  backgroundColor: Color(0xFF1B2A3B),
                  textColor: Colors.white),
              ChipPill(
                  label: "Child Behavior & Safety",
                  icon: Icons.verified_user,
                  backgroundColor: Color(0xFF1B2A3B),
                  textColor: Colors.white),
            ],
          ),
          const SizedBox(height: 24),

          // Skills
          const Text(
            "Skills",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              ChipPill(label: "Special Needs Support"),
              ChipPill(label: "Meal Prep"),
              ChipPill(label: "Safe Sleep Practices"),
              ChipPill(label: "Meal Preparation"), // Duplicate in design list?
              ChipPill(label: "Potty Training"),
              ChipPill(label: "Sensory Play"),
              ChipPill(label: "Medication Management"),
              ChipPill(label: "Light Housekeeping"),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textSecondary)), // Approx
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 12,
      width: 1,
      color: AppColors.neutral30, // Grey divider
    );
  }
}
