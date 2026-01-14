import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class BottomCtaBar extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BottomCtaBar({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.surfaceWhite, // Bar background usually white
      child: SafeArea(
        // Handle bottom notch
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.screenHorizontalPadding,
            vertical: 16, // Typical padding
          ),
          child: SizedBox(
            height: AppTokens.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
                ),
                elevation: 0,
              ),
              child: Text(label, style: AppTokens.buttonText),
            ),
          ),
        ),
      ),
    );
  }
}
