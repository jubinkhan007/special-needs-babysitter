import 'package:flutter/material.dart';
import 'package:core/core.dart';

class HomeDesignTokens {
  HomeDesignTokens._();

  // Layout
  static const double horizontalPadding = 24.0;
  static const double sectionSpacing =
      32.0; // Increased to match Figma breathing room
  static const double headerBottomSpacing = 24.0;
  static const double itemSpacing = 16.0;

  // Radii
  static const double searchBarRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double smallCardRadius = 12.0;
  static const double buttonRadius = 8.0;

  // Sizes
  static const double promoBannerHeight =
      210.0; // Adjusted to fully fix overflow
  static const double activeBookingCardHeight = 180.0; // Approx
  static const double sitterNearYouWidth = 300.0;
  static const double sitterNearYouHeight = 244.0; // Tweak as needed
  static const double savedSitterWidth = 140.0;
  static const double savedSitterHeight =
      190.0; // accommodates image + bottom info
  static const double savedSitterImageHeight = 120.0;

  // Shadows
  static List<BoxShadow> get defaultCardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06), // Subtle shadow
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get bannerShadow => [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.25), // Blue-ish shadow
          blurRadius: 16,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        )
      ];

  // Typography helpers (specific adjustments for Home)
  // Chip Tokens
  static const double chipRadius = 20.0;
  static const Color chipBackground = Color(0xFFF2F4F7); // Light grey/blue
  static const Color chipText = Color(0xFF344054);

  // Custom Bottom Nav
  static const double bottomNavHeight = 84.0;
  static const Color bottomNavSelected = AppColors.primary;
  static const Color bottomNavUnselected = Color(0xFF98A2B3);

  // Typography helpers (specific adjustments for Home)
  static TextStyle get sectionHeader => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary, // Corrected to textPrimary
        letterSpacing: -0.5,
      );

  static TextStyle get seeAllText => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get cardTitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardSubtitle => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get priceLarge => const TextStyle(
        fontSize: 22, // Big price
        fontWeight: FontWeight.w700,
        color: Color(0xFF1B4D68), // Dark Teal/Blue
        letterSpacing: -0.5,
      );

  static TextStyle get priceUnit => const TextStyle(
        color: AppColors.neutral40,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get chipLabel => const TextStyle(
        color: chipText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get statLabel => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.neutral30,
      );

  static TextStyle get statValue => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral60,
      );

  static const Color viewProfileButtonBg = Color(0xFF86C9E8);
}
