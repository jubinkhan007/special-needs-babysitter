import 'package:flutter/material.dart';

class AccountUI {
  // Colors
  static const Color accentBlue = Color(0xFF62A8FF);
  static const Color backgroundBlue = Color(0xFFF7F9FC); // Light blue tint
  static const Color textDark = Color(0xFF1D2939);
  static const Color textGray = Color(0xFF667085);
  static const Color cardShadow = Color(0x0D101828); // Soft shadow

  // Dimensions
  static const double cardRadius = 20.0;
  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double avatarSize = 64.0;

  // Text Styles (Helpers if Theme isn't enough)
  static TextStyle get titleStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textDark,
      );

  static TextStyle get subtitleStyle => const TextStyle(
        fontSize: 14,
        color: textGray,
        fontWeight: FontWeight.w400,
      );

  // Box Decoration Helper
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: const [
          BoxShadow(
            color: cardShadow,
            offset: Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      );
}
