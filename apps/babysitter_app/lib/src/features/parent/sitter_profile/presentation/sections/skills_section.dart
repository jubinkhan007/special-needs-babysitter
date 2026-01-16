import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
import '../widgets/certification_chip.dart';
import '../widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  final List<String> languages;
  final List<String> certifications;
  final List<String> skills;

  const SkillsSection({
    super.key,
    this.languages = const [],
    this.certifications = const [],
    this.skills = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Languages
          if (languages.isNotEmpty) ...[
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
                for (int i = 0; i < languages.length; i++) ...[
                  _buildLanguageItem(languages[i]),
                  if (i < languages.length - 1) _buildDivider(),
                ],
              ],
            ),
            const SizedBox(height: 32),
          ],

          // Certifications
          if (certifications.isNotEmpty) ...[
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
              children: certifications
                  .map((cert) => CertificationChip(label: cert))
                  .toList(),
            ),
            const SizedBox(height: 32),
          ],

          // Skills
          if (skills.isNotEmpty) ...[
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
              children: skills.map((skill) => SkillChip(label: skill)).toList(),
            ),
          ],
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
