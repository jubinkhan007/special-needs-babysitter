import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class AgeExperienceItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const AgeExperienceItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, // Fixed size
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFFB2DDFF),
                width: 1.5), // Light Blue stroke
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7CD4FD), // Light Blue icon
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppUiTokens.textPrimary,
          ),
        ),
      ],
    );
  }
}
