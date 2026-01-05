import 'package:flutter/material.dart';

/// Auth theme constants matching Figma design
class AuthTheme {
  AuthTheme._();

  // Colors
  static const Color backgroundColor = Color(0xFFD6EDF6); // Light blue
  static const Color primaryBlue = Color(0xFF4A9CC7); // Primary action blue
  static const Color textDark = Color(0xFF1A3A4A); // Dark navy text
  static const Color coralAccent = Color(0xFFE8896B); // Coral/salmon accent
  static const Color errorRed = Color(0xFFE74C3C);
  static const Color inputBackground = Colors.white;
  static const Color inputBorder = Color(0xFFE0E8EC);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textDark,
    letterSpacing: -0.3,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    color: textDark.withOpacity(0.6),
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textDark,
  );

  // Input decoration
  static InputDecoration inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textDark.withOpacity(0.7),
      ),
      hintStyle: TextStyle(
        fontSize: 15,
        color: textDark.withOpacity(0.4),
      ),
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: coralAccent,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: textDark,
    backgroundColor: Colors.white,
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}
