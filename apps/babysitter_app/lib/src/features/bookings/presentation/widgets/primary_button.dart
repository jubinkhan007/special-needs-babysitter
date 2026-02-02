// primary_button.dart
import 'package:babysitter_app/src/common_widgets/debounced_button.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Duration debounceDuration;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return DebouncedGestureDetector(
      onTap: onPressed,
      debounceDuration: debounceDuration,
      child: SizedBox(
        width: double.infinity,
        height: AppTokens.buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTokens.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
            ),
          ),
          child: Text(label, style: AppTokens.buttonText),
        ),
      ),
    );
  }
}
