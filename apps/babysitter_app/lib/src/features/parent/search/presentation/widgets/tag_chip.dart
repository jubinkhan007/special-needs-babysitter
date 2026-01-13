import 'package:flutter/material.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart';

class TagChip extends StatelessWidget {
  final String label;

  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppUiTokens.chipBackground,
        borderRadius: BorderRadius.circular(AppUiTokens.radiusCircle),
      ),
      child: Text(
        label,
        style: AppUiTokens.chipLabel,
      ),
    );
  }
}
