import 'package:flutter/material.dart';

/// Centralized UI tokens for the Sitter Search feature to ensure pixel-perfect matching with Figma.
///
/// NO MAGIC NUMBERS allowed in widgets. Use these constants instead.
class AppUiTokens {
  AppUiTokens._();

  // ===========================================================================
  // Colors
  // ===========================================================================

  // Backgrounds
  static const Color scaffoldBackground =
      Color(0xFFF9FAFB); // Light Grey/Off-white
  static const Color cardBackground = Colors.white;
  static const Color topBarBackground = Color(0xFFF0F9FF); // Light Blue

  // Text
  static const Color textPrimary = Color(0xFF101828); // Darkest Grey/Black
  static const Color textSecondary = Color(0xFF667085); // Medium Grey
  static const Color textPrice =
      Color(0xFF101828); // Same as primary but explicitly for price

  // Brand/Accents
  static const Color primaryBlue = Color(0xFF7CD4FD); // Light Blue Button
  static const Color verifiedBlue = Color(0xFF2E90FA); // Verified Badge
  static const Color starYellow = Color(0xFFFAC515); // Star Icon

  // Chips
  static const Color chipBackground = Color(0xFFF2F4F7); // Light Grey
  static const Color chipText = Color(0xFF344054); // Dark Grey

  // Borders & Shadows
  static const Color borderColor = Color(0xFFEAECF0); // Subtle Border
  static const Color iconBoxBorder = Color(0xFFEAECF0);

  // ===========================================================================
  // Typography
  // ===========================================================================

  // Font Family matches app default (likely Inter or similar sans-serif)

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.2, // Subtle tracking
  );

  static const TextStyle filterText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle cardName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle cardLocation = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle cardRating = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle metricLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle metricValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: chipText,
  );

  static const TextStyle priceValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrice,
    letterSpacing: -0.5,
  );

  static const TextStyle priceUnit = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle searchPlaceholder = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF98A2B3),
  );

  // ===========================================================================
  // Spacing & Dimensions
  // ===========================================================================

  static const double horizontalPadding = 16.0; // Standard screen padding
  static const double cardPadding = 16.0; // Padding inside cards

  static const double itemSpacing = 16.0; // Spacing between cards

  // Search Bar
  static const double searchBarHeight = 48.0;

  // Avatars
  static const double avatarSize = 48.0; // Diameter

  // Icons
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double verifiedIconSize = 16.0;

  // Bookark Icon Box
  static const double bookmarkBoxSize = 36.0;

  // Filter Pill
  static const double filterPillHeight = 36.0;

  // View Profile Button
  static const double buttonHeight = 40.0;
  static const double buttonWidth =
      120.0; // Or flexible? Design looks fixed or constrained

  // ===========================================================================
  // Border Radii
  // ===========================================================================

  static const double radiusSmall = 8.0; // Buttons, Icon boxes
  static const double radiusMedium = 12.0; // Search bar, Filter pill
  static const double radiusLarge = 16.0; // Cards
  static const double radiusCircle = 100.0; // Pills, Avatars

  // ===========================================================================
  // Shadows
  // ===========================================================================

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF101828).withOpacity(0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0xFF101828).withOpacity(0.03),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -2,
        ),
      ];
}
