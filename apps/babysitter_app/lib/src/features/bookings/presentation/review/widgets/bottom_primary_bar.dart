import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class BottomPrimaryBar extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BottomPrimaryBar({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.screenHorizontalPadding,
        vertical: AppTokens.bottomBarPadding,
      ),
      child: SafeArea(
        // Ensure bottom safe area
        top: false,
        child: SizedBox(
          height: AppTokens.buttonHeight,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTokens.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
              ),
            ),
            child: Text(label, style: AppTokens.buttonText),
          ),
        ),
      ),
    );
  }
}
