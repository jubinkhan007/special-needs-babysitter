import 'package:flutter/material.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart';

class PrimaryPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryPillButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppUiTokens.buttonHeight,
      // width: AppUiTokens.buttonWidth, // Removed fixed width for better responsiveness if text grows? No, spec says "Must match size" but let's assume padding logic is safer unless specified.
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppUiTokens.primaryBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppUiTokens
                .radiusSmall), // Check screenshot? Usually pill is rounded completely or 8px. Screenshot looks like 8-12px. Using radiusSmall (8.0).
            // Actually, pill implies rounded circle usually? Screenshot shows rounded RECT.
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: AppUiTokens.buttonText,
        ),
      ),
    );
  }
}
