import 'package:flutter/material.dart';

class AddChildButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddChildButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1D2939), // Dark Navy
        foregroundColor: Colors.white,
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
