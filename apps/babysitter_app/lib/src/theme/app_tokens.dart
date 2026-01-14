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

  static const Color chipPurpleBg = Color(0xFFF0E4FF); // Completed
  static const Color chipPurpleDot = Color(0xFF9747FF);

  // ========= Booking Details Specific =========
  static const Color bookingDetailsHeaderBg = Color(0xFFF3FAFD);
  static const Color bookingDetailsCardBg = Colors.white;
  static const Color bookingDetailsDivider = Color(0xFFE4F4FC);

  static const Color skillTagBg = Color(0xFFF3FAFD);
  static const Color skillTagText = Color(0xFF54595C);
  static const double skillTagRadius = 8;
  static const double skillTagVerticalPadding = 6;
  static const double skillTagHorizontalPadding = 12;

  static TextStyle get sectionTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get detailKey => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5, // Taller line height for readability
      );

  static TextStyle get detailValue => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get totalCostLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.2,
      );

  static TextStyle get totalCostValue => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get skillTagStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: skillTagText,
        height: 1.2,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // REVIEW & REPORT SCREENS TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color formFieldBg = Colors.white;
  static const Color formFieldBorder = Color(0xFFE4F4FC);
  static const Color formFieldHint = Color(0xFF8A949C);
  static const Color formFieldText = textPrimary;
  static const double formFieldRadius = 12;
  static const double formFieldPaddingX = 16;
  static const double formFieldPaddingY = 16;

  static const Color uploadTileBg = Color(0xFFF0F4F8); // Subtle grey/blue
  static const Color uploadTileIconColor = primaryBlue;
  static const Color uploadTileText = textSecondary;
  static const double uploadTileRadius = 12;
  static const double uploadTileSize = 80;

  static const Color outlinedButtonBorder = Color(0xFFE4F4FC); // Or divider
  static const Color outlinedButtonText = textPrimary;

  static const double bottomBarHeight = 80;
  static const double bottomBarPadding = 16;
  // bottom action bar often uses screen horizontal padding (24)

  static TextStyle get formHintStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: formFieldHint,
        height: 1.4,
      );

  static TextStyle get formTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: formFieldText,
        height: 1.4,
      );

  static TextStyle get subLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get helperTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      );

  static TextStyle get uploadTileTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: uploadTileText,
        height: 1.2, // Tighter for wrapping
      );

  static TextStyle get outlinedButtonTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: outlinedButtonText,
        height: 1.2,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIVE BOOKING DETAILS TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color activeHeaderBg = Color(0xFFF3FAFD);
  static const Color mapCardBg = Colors.white;
  static const Color mapRouteBlue = Color(0xFF89CFF0);
  static const Color mapPinDark = Color(0xFF1B2225);
  static const Color linkTextGrey = Color(0xFF8A949C);
  static const Color sectionTitleColor = Color(0xFF1B2225);
  static const Color dashedDividerColor = Color(0xFFE4F4FC);

  // Layout
  static const double detailsHorizontalPadding = 24.0;
  static const double detailsSectionTopGap = 24.0;
  static const double detailsHeaderBottomGap = 24.0;
  static const double mapHeight = 220.0;
  static const double mapCardRadius = 16.0;

  static const double bottomCtaHeight = 48.0;
  static const double bottomCtaGap = 16.0;
  static const double bottomCtaRadius = 12.0;

  // Typography
  static TextStyle get activeSectionTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: sectionTitleColor,
        height: 1.2,
      );

  static TextStyle get linkTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: linkTextGrey,
        height: 1.2,
      );

  static TextStyle get kvLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get kvValue => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight
            .w500, // Slightly less bold than w600 if needed, or match detailValue
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get kvValueStrong => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // MAP ROUTE SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color mapRouteHeaderBg = Color(0xFFF3FAFD);
  static const double mapRouteHeaderHeight = 56.0;
  static const Color mapRouteIconColor = Color(0xFF8A949C);

  static const Color routeCardBg = Colors.white;
  static const double routeCardRadius =
      24.0; // Slightly rounder for bottom sheet look
  static const List<BoxShadow> routeCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];
  static const double routeCardPadding = 24.0;
  static const double routeCardMarginHorizontal = 16.0;
  static const double routeCardBottomInset = 34.0; // Lift above gesture bar

  static const double routeRowGapVertical = 28.0;

  static const double routeDotSize = 12.0;
  static const Color routeDotActiveFill = Color(0xFF89CFF0);
  static const Color routeDotInactiveFill = Colors.white;
  static const Color routeDotBorderColor = Color(0xFFE4F4FC);
  static const Color routeConnectorColor = Color(0xFFE4F4FC);

  static TextStyle get routeAddressTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get routeTimeTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.2,
      );
}
