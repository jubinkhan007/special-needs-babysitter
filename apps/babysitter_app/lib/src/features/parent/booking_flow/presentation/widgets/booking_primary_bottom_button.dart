import 'package:flutter/material.dart';
import '../../../search/presentation/theme/app_ui_tokens.dart';

class BookingPrimaryBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BookingPrimaryBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48, // Standard height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppUiTokens.primaryBlue, // Light Blue
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Match input radius
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold per checklist
          ),
        ),
      ),
    );
  }
}
