import 'package:flutter/material.dart';

class ProfileDetailsUI {
  // Spacing
  static const double screenPadding = 16.0;
  static const double cardSpacing = 16.0;
  static const double contentSpacing = 12.0;

  // Radius
  static const double cardRadius = 20.0;

  // Colors
  static const Color scaffoldBackground =
      Color(0xFFF7F9FC); // Light gray/blue tint
  static const Color cardBackground = Colors.white;
  static const Color appBarBackground = Color(0xFFF0F8FF); // Light sky blue
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF667085);
  static const Color labelText = Color(0xFF344054);

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  // Text Styles
  static TextStyle get sectionTitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      );

  static TextStyle get fieldLabel => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      );

  static TextStyle get fieldValue => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        height: 1.4,
      );
}
