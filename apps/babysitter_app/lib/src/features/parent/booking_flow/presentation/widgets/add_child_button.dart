import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AddChildButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddChildButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonDark, // Dark Navy
        foregroundColor: AppColors.textOnButton,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Pill-ish / High rounding
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 24), // Add horizontal padding
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text('Add Child'),
    );
  }
}
