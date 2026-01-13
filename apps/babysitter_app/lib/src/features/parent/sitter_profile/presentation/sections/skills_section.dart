import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../widgets/certification_chip.dart';
import '../widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Languages
          const Text(
            "Languages",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
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
          const SizedBox(height: 32),

          // Certifications
          const Text(
            "Certifications",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              CertificationChip(label: "CPR & First Aid"),
              CertificationChip(label: "Special Needs Childcare"),
              CertificationChip(label: "Infant Care"),
              CertificationChip(label: "Child Behavior & Safety"),
            ],
          ),
          const SizedBox(height: 32),

          // Skills
          const Text(
            "Skills",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              SkillChip(label: "Special Needs Support"),
              SkillChip(label: "Meal Prep"),
              SkillChip(label: "Safe Sleep Practices"),
              SkillChip(label: "Meal Preparation"),
              SkillChip(label: "Potty Training"),
              SkillChip(label: "Sensory Play"),
              SkillChip(label: "Medication Management"),
              SkillChip(label: "Light Housekeeping"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12), // Figma shows wide spacing
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: AppUiTokens.textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 14,
      width: 1,
      color: const Color(0xFFD0D5DD), // Lighter grey divider
    );
  }
}
