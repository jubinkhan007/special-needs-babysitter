import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Single source of truth for all design tokens in the Bookings feature.
/// All colors, typography, spacing, and radii are defined here.
class AppTokens {
  AppTokens._();

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORS - Core Surfaces
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color screenBg = Color(0xFFF3FAFD); // Very light blue background
  static const Color tabsStripBg = Color(0xFFFFFFFF); // White tabs strip
  static const Color divider = Color(0xFFE4F4FC); // Same as card border

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORS - Primary / Accent
  // ═══════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORS - Text
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color appBarTitleColor = Color(0xFF54595C); // Gray

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORS - Accent / Status
  // ═══════════════════════════════════════════════════════════════════════════

  // Status Chip Colors (Pastel, softened)
  // static const Color chipBlueBg = Color(0xFFE1F5FE);
  // static const Color chipBlueDot = Color(0xFF89CFF0);
  // static const Color chipGreenBg = Color(0xFFE8F5E9);
  // static const Color chipGreenDot = Color(0xFF4CAF50);
  // static const Color chipOrangeBg = Color(0xFFFFF3E0);
  // static const Color chipOrangeDot = Color(0xFFFF9800);
  // static const Color chipGreyBg = Color(0xFFF5F5F5);
  // static const Color chipGreyDot = Color(0xFF9E9E9E);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORS - Shadow
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.06);

  // ═══════════════════════════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════════════════════════
  static double get listTopPadding => 18.h;
  static double get cardSpacing => 18.h; // Between cards

  // ═══════════════════════════════════════════════════════════════════════════
  // TABS
  // ═══════════════════════════════════════════════════════════════════════════
  static double get tabsStripHeight => 60.h;
  static double get tabPillHorizontalPadding => 18.w;
  static double get tabPillVerticalPadding => 10.h;
  static double get tabGap => 14.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD
  // ═══════════════════════════════════════════════════════════════════════════
  static double get cardDividerSpacing => 16.h; // Above and below divider

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTONS
  // ═══════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get ratingText => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.2,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BOX SHADOW (Subtle)
  // ═══════════════════════════════════════════════════════════════════════════

  static List<BoxShadow> get appBarShadow => [
        BoxShadow(
          color: shadowColor,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static const Color bg = Color(0xFFF3FAFD); // light blue page background
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  static const Color primaryBlue = Color(0xFF89CFF0); // selected pill + buttons
  static const Color accentBlue = Color(0xFF89CFF0);

  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE4F4FC);

  static const Color textPrimary = Color(0xFF1B2225);
  static const Color textSecondary = Color(0xFF6B7680);
  static const Color appBarTitleGrey = Color(0xFF54595C);
  static const Color iconGrey = Color(0xFF8A949C);

  static const Color starYellow = Color(0xFFF5B301);

  static const Color darkButtonBg =
      Color(0xFF1F2B35); // dark navy (View Details)
  static const Color dividerSoft = Color(0xFFE4F4FC);

  // ========= Layout =========
  static const double screenHorizontalPadding = 24;

  static const double appBarHeight = 56;

  static const double tabsHeight = 56;
  static const double tabsVerticalPadding = 10;
  static const double tabPillRadius = 499;

  static const double cardRadius = 16;
  static const double cardInternalPadding = 16;

  static const double avatarSize = 48;

  static const double buttonHeight = 48;
  static const double buttonRadius = 12;
  static const double buttonSpacing = 10;

  static const double statIconSize = 18;

  // ========= Shadows (soft like Figma) =========
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.06);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: shadow,
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  // ========= Typography =========
  // If you have SF Pro in pubspec, set fontFamily here; else Flutter default is fine.
  static const String? fontFamily = null;

  static TextStyle get appBarTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: appBarTitleGrey,
        height: 1.2,
      );

  static TextStyle get tabSelected => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      );

  static TextStyle get tabUnselected => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get cardName => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.15,
      );

  static TextStyle get cardMeta => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.2,
      );

  static TextStyle get statLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.2,
      );

  static TextStyle get statValue => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.1,
      );

  static TextStyle get scheduledText => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get chipText => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get buttonText => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      );

  // ========= Status chip palette (soft/pastel) =========
  static const Color chipBlueBg = Color(0xFFD9F0FF);
  static const Color chipBlueDot = Color(0xFF5DBBFF);

  static const Color chipGreenBg = Color(0xFFDFF6E6);
  static const Color chipGreenDot = Color(0xFF35C76A);

  static const Color chipOrangeBg = Color(0xFFFFE8C9);
  static const Color chipOrangeDot = Color(0xFFFF9F1A);

  static const Color chipGreyBg = Color(0xFFEFF2F5);
  static const Color chipGreyDot = Color(0xFF9AA3AB);
}
