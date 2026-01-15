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
  // ═══════════════════════════════════════════════════════════════════════════
  // JOBS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  // Screen & List
  static const Color jobsScreenBg = Color(0xFFF3FAFD); // Matches booking bg
  static const double jobsListHorizontalPadding = 16.0;
  static const double jobsListTopPadding = 24.0;
  static const double jobsCardSpacing = 16.0;

  // App Bar
  static const Color jobsAppBarBg = Color(0xFFF3FAFD);
  static TextStyle get jobsAppBarTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: textSecondary, // Grey title per screenshot
      );
  static const Color jobsAppBarIconColor = Color(0xFF8A949C);
  static const List<BoxShadow> jobsAppBarShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  // Card
  static const Color jobsCardBg = Colors.white;
  static const Color jobsCardBorder = Color(0xFFE4F4FC); // Subtle border
  static const double jobsCardRadius = 12.0;
  static const List<BoxShadow> jobsCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  static const double jobsCardPadding = 16.0;
  static TextStyle get jobsCardTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  // Status Chip
  static const Color jobChipBgActive =
      Color(0xFFE0F2F1); // Light blue/teal pill
  static const Color jobChipDotActive = Color(0xFF00B0FF); // Vivid blue dot
  static TextStyle get jobChipTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      );
  static const double jobChipRadius = 100.0;
  static const double jobChipHeight = 24.0;
  static const double jobChipHorizontalPadding = 8.0;

  // Info Grid
  static const Color jobInfoIconColor = Color(0xFF8A949C);
  static const double jobInfoIconSize = 18.0;
  static TextStyle get jobInfoLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );
  static TextStyle get jobInfoValueStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.3,
      );
  static const Color jobInfoValueAccentColor =
      Color(0xFF2D8EFF); // Blue for (4y)

  static const double jobInfoColumnGap = 16.0;
  static const double jobInfoRowGap = 16.0;
  static const double jobInfoLabelValueGap = 4.0;

  // Divider + Buttons
  static const Color jobDividerColor = Color(0xFFF0F0F0);
  static const double jobDividerThickness = 1.0;
  static const double jobButtonsTopPadding = 16.0;
  static const double jobButtonHeight = 48.0;
  static const double jobButtonRadius = 8.0;
  static const Color jobPrimaryBtnBg = Color(0xFF89CFF0); // Light blue
  static const Color jobSecondaryBtnBg = Color(0xFF1A2B3C); // Dark Navy
  static TextStyle get jobButtonTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.0, // Fix vertical alignment/clipping
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // JOB DETAILS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  // Screen
  static const Color jobDetailsBg = Color(0xFFF3FAFD); // Matches all jobs bg
  static const double jobDetailsHorizontalPadding = 16.0;
  static const double jobDetailsTopPadding = 16.0;
  static const double jobDetailsSectionSpacing = 24.0;
  static const double jobDetailsBottomPaddingForScroll =
      120.0; // Space for sticky bottom bar

  // Typography
  static TextStyle get jobDetailsTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );
  static TextStyle get jobDetailsSubtitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );
  static TextStyle get jobDetailsSectionTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );
  static TextStyle get jobDetailsLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary, // Grey
      );
  static TextStyle get jobDetailsValueStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary, // Dark
      );
  static TextStyle get jobDetailsParagraphStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary, // Grey
        height: 1.5,
      );

  // Dividers
  static const Color jobDetailsDividerColor = Color(0xFFF0F0F0);
  static const double jobDetailsDividerThickness = 1.0;
  static const double jobDetailsSectionDividerPaddingY = 16.0;

  // Buttons
  static const double jobDetailsButtonHeight = 48.0;
  static const double jobDetailsButtonRadius = 8.0;
  static const double jobDetailsButtonGap = 12.0;

  static const Color jobDetailsPrimaryBtnBg = Color(0xFF89CFF0); // Light blue
  static const Color jobDetailsSecondaryBtnBg = Color(0xFF1A2B3C); // Dark Navy
  static const Color jobDetailsOutlinedBorderColor = Color(0xFFE0E0E0);
  static const Color jobDetailsOutlinedTextColor = Color(0xFF1A2B3C);

  static TextStyle get jobDetailsButtonTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.0,
      );
  static TextStyle get jobDetailsOutlinedTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: jobDetailsOutlinedTextColor,
        height: 1.0,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // APPLICATIONS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  // Screen
  static const Color applicationsBg = Color(0xFFF3FAFD); // Matches bookings bg
  static const double applicationsHorizontalPadding = 16.0;
  static const double applicationsTopPadding = 16.0;
  static const double applicationsCardGap = 16.0;

  // Card
  static const double applicationsCardPadding = 16.0;
  static const Color applicationsInnerDividerColor = Color(0xFFF0F0F0);

  // Typography
  static TextStyle get applicationsNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );
  static TextStyle get applicationsMetaStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary, // Grey
      );
  static TextStyle get applicationsJobTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );
  static TextStyle get applicationsScheduledStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary, // Darker than meta
      );
  static TextStyle get applicationsStatLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary, // Grey
      );
  static TextStyle get applicationsStatValueStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );
  static TextStyle get applicationsRatingTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  // Chip (Application specific)
  static const Color applicationChipBg = Color(0xFFFCE4F4); // Pink/Lavender
  static const Color applicationChipDot = Color(0xFFD3009B); // Pink/Magenta
  static TextStyle get applicationChipTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // BOOKING APPLICATION SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  // Layout
  static const double sectionTopGap = 24.0;
  static const double sectionGap = 24.0;
  static const double pageBottomSpacer = 40.0;
  static const double bookingApplicationBottomBarPadding =
      16.0; // Renamed to avoid key collision
  static const double bottomBarGap = 12.0;

  // Dashed Divider
  static const Color dashColor = Color(0xFFE0E0E0);
  static const double dashHeight = 1.0;
  static const double dashGap = 4.0;
  static const double dashLength = 4.0;

  // Typography
  static TextStyle get sectionTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827), // Dark Title
      );
  static TextStyle get bodyParagraphStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280), // Body/Grey
        height: 1.5,
      );
  static TextStyle get transportLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151), // Darker Grey/Label
      );
  static TextStyle get transportValueStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280), // Body/Grey
        height: 1.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // REJECT REASON BOTTOM SHEET TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  // Sheet
  static const Color rejectSheetBg = Colors.white;
  static const double rejectSheetTopRadius = 24.0;
  static const double rejectSheetHorizontalPadding = 20.0;
  static const Color rejectSheetCloseIconColor = Color(0xFF6B7280);
  static const double rejectSheetCloseIconSize = 24.0;
  static TextStyle get rejectSheetTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
      );

  // Radio Rows
  static const Color rejectRadioOuterColor = Color(0xFFD1D5DB); // Grey outline
  static const Color rejectRadioSelectedColor = Color(0xFF5EBFC0); // Cyan/Teal
  static const double rejectRadioRowHeight = 52.0;
  static const double rejectRadioGap = 16.0;
  static TextStyle get rejectRadioTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF374151),
      );

  // Add Other Field
  static const Color rejectOtherFieldBorderColor =
      Color(0xFFD1D5DB); // Light grey border
  static const Color rejectOtherFieldBg = Color(0xFFFFFFFF); // White
  static const double rejectOtherFieldRadius = 8.0;
  static const double rejectOtherFieldHeight = 52.0; // Match button height
  static const EdgeInsets rejectOtherFieldPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static TextStyle get rejectOtherHintStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      );
  static TextStyle get rejectOtherTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF374151),
      );
  static const Color rejectOtherPlusIconColor = Color(0xFF6B7280);
  static const double rejectOtherPlusIconSize = 20.0;

  // Submit Button
  static const double rejectSubmitHeight = 52.0;
  static const double rejectSubmitRadius = 12.0;
  static const Color rejectSubmitBg = Color(0xFF89CFF0); // Baby blue
  static const Color rejectSubmitTextColor = Colors.white;
  static TextStyle get rejectSubmitTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18, // Slightly larger for better match
        fontWeight: FontWeight.w600,
        color: rejectSubmitTextColor,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Background + Surfaces
  static const Color accountBg = Color(0xFFF3FAFD); // Same pale blue
  static const Color accountCardBg = Color(0xFFFFFFFF);
  static const Color accountCardBorder = Color(0xFFE8F4FA); // Very light border
  static const double accountCardRadius = 16.0;
  static List<BoxShadow> get accountCardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  // Typography
  static TextStyle get accountNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get accountEmailStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get accountLinkStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF89CFF0),
      );
  static TextStyle get accountStatNumberStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get accountStatLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get accountMenuTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      );

  // Spacing
  static const double accountScreenHPad = 20.0;
  static const double accountSectionGap = 16.0;
  static const double accountCardInternalPad = 16.0;
  static const double accountMenuTileHeight = 56.0;
  static const double accountMenuTileRadius = 12.0;

  // Colors
  static const Color accountLinkBlue = Color(0xFF89CFF0);
  static const Color accountIconGrey = Color(0xFF6B7280);
  static const Color accountMenuBorder = Color(0xFFE5E7EB);

  // Progress Ring
  static const Color progressRingTrack = Color(0xFFE5E7EB);
  static const Color progressRingValue = Color(0xFF89CFF0);
  static const Color progressBadgeBg = Color(0xFF89CFF0);
  static const Color progressBadgeText = Color(0xFFFFFFFF);
  static const double progressAvatarSize = 64.0;
  static const double progressRingStroke = 3.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Screen layout
  static const Color settingsBg = Color(0xFFF3FAFD);
  static const double settingsHPad = 20.0;
  static const double settingsTopPad = 16.0;
  static const double settingsTileGap = 12.0;

  // Tile styling (reuse account tile style)
  static const Color settingsTileBg = Color(0xFFFFFFFF);
  static const Color settingsTileBorder = Color(0xFFE5E7EB);
  static const double settingsTileRadius = 12.0;
  static const double settingsTileHeight = 56.0;
  static const double settingsTileInternalHPad = 16.0;
  static const double settingsIconSize = 24.0;
  static const Color settingsIconColor = Color(0xFF6B7280);

  // Typography
  static TextStyle get settingsTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      );

  // Switch styling
  static const Color settingsSwitchActiveTrack = Color(0xFF89CFF0);
  static const Color settingsSwitchActiveThumb = Color(0xFFFFFFFF);
  static const Color settingsSwitchInactiveTrack = Color(0xFFE5E7EB);
  static const Color settingsSwitchInactiveThumb = Color(0xFFFFFFFF);
  static const double settingsSwitchScale = 0.85;

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Screen layout
  static const Color paymentBg = Color(0xFFFFFFFF);
  static const Color paymentHeaderBg = Color(0xFFF3FAFD);
  static const double paymentHPad = 24.0;
  static const double paymentSectionGapTop = 24.0;
  static const double paymentSectionGapBottom = 12.0;

  // Section titles
  static TextStyle get paymentSectionTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );

  // Balance card
  static const Color balanceCardBg = Color(0xFFFFFFFF);
  static const double balanceCardRadius = 16.0;
  static List<BoxShadow> get balanceCardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
  static const EdgeInsets balanceCardPadding = EdgeInsets.all(20);
  static TextStyle get balanceLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get balanceAmountStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get topUpTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF6B7280),
      );
  static const Color topUpIconColor = Color(0xFF6B7280);
  static const double topUpIconSize = 20.0;

  // Payment method rows
  static const double methodRowHeight = 56.0;
  static const double methodIconCircleSize = 40.0;
  static const Color methodIconCircleBorder = Color(0xFFE5E7EB);
  static TextStyle get methodTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      );
  static const Color methodPlusColor = Color(0xFF9CA3AF);
  static const double methodPlusSize = 20.0;
  static const double methodRowGap = 8.0;

  // Recent activity rows
  static const double activityRowHeight = 64.0;
  static TextStyle get activityTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get activityDateStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get activityAmountStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );
  static const double activityLeadingIconSize = 24.0;
  static const Color activityLeadingIconColor = Color(0xFF6B7280);

  // ═══════════════════════════════════════════════════════════════════════════
  // SAVED SITTERS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Screen layout
  static const Color savedSittersHeaderBg = Color(0xFFF3FAFD);
  static const Color savedSittersBodyBg = Color(0xFFFFFFFF);
  static const double savedSittersHPad = 20.0;

  // Search field
  static const Color searchFieldBg = Color(0xFFFFFFFF);
  static const Color searchFieldBorder = Color(0xFFE5E7EB);
  static const double searchFieldRadius = 12.0;
  static const double searchFieldHeight = 52.0;
  static const Color searchIconColor = Color(0xFF9CA3AF);
  static TextStyle get searchFieldHintStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      );
  static TextStyle get searchFieldTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1F2937),
      );

  // List header row
  static TextStyle get listHeaderTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );

  // Filter pill
  static const Color filterPillBg = Color(0xFFFFFFFF);
  static const Color filterPillBorder = Color(0xFFE5E7EB);
  static const double filterPillRadius = 20.0;
  static const double filterPillHeight = 36.0;
  static TextStyle get filterPillTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static const Color filterPillIconColor = Color(0xFF6B7280);

  // Saved sitter card
  static const double savedCardRadius = 16.0;
  static const Color savedCardBg = Color(0xFFFFFFFF);
  static const Color savedCardBorder = Color(0xFFE8F4FA);
  static List<BoxShadow> get savedCardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
  static TextStyle get savedSitterNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get savedSitterLocationStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get savedStatLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static TextStyle get savedStatValueStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get savedPriceBigStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
      );
  static TextStyle get savedPriceSuffixStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );
  static const Color viewProfileButtonBg = Color(0xFF89CFF0);
  static const double viewProfileButtonRadius = 20.0;
  static TextStyle get viewProfileButtonTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFFFFFFF),
      );
  static const Color bookmarkContainerBg = Color(0xFFFFFFFF);
  static const Color bookmarkContainerBorder = Color(0xFFE5E7EB);
  static const Color bookmarkIconColor = Color(0xFF1F2937);
  static const Color ratingStarColor = Color(0xFFFBBF24);
  static TextStyle get savedRatingTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // REVIEWS SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Layout & Backgrounds
  static const Color reviewsHeaderBg = Color(0xFFF3FAFD);
  static const double reviewsTopSpacing = 24.0;
  static const double reviewItemVerticalPadding = 16.0;
  static const Color reviewItemDividerColor =
      Color(0xFFF3F4F6); // Very light grey
  static const double reviewItemDividerThickness = 1.0;

  // Typography
  static TextStyle get reviewsTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16, // Medium-bold, likely 16 or 18
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );

  static TextStyle get reviewsSummaryStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );

  static TextStyle get reviewerNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
      );

  static TextStyle get reviewTimeAgoStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11, // Small grey text
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      );

  static TextStyle get reviewCommentStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4B5563),
        height: 1.5, // Tuned/comfortable line height
      );

  // Avatar
  static const double reviewAvatarSize = 40.0;
  static const double reviewAvatarRadius = 20.0; // Half of size
  static const Color avatarPlaceholderBg = Color(0xFFE5E7EB);

  // Stars
  static const double starsSize = 14.0;
  static const double starsGap = 2.0; // Space between stars
  static const Color starFilledColor =
      Color(0xFFFBBF24); // Same as ratingStarColor
  static const Color starEmptyColor = Color(0xFFE5E7EB); // Light grey
  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER SHEET TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Sheet Layout
  static const Color sheetBg = Color(0xFFFFFFFF);
  static const double sheetRadiusTop = 24.0;
  static const double sheetHorizontalPadding = 24.0;
  static const double sheetTopPadding = 24.0;
  static const double sheetSectionSpacing = 24.0;
  static const double sheetFieldSpacing = 16.0;

  // Typography
  static TextStyle get sheetTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
        height: 1.2,
      );

  static TextStyle get sheetSectionTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15, // Label size
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );

  static TextStyle get sheetFieldHintStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      );

  static TextStyle get sheetFieldTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      );

  static TextStyle get sheetCheckboxTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4B5563),
      );

  // Form Fields (Sheet specific)
  static const Color sheetFieldBg = Color(0xFFFFFFFF);
  static const Color sheetFieldBorder = Color(0xFFE5E7EB);
  static const double sheetFieldRadius = 12.0;
  static const double sheetFieldHeight = 48.0;
  static const double sheetFieldPadding = 16.0;
  static const Color sheetFieldIconColor = Color(0xFF6B7280);

  // Slider
  static const Color sliderActiveColor = Color(
      0xFF87CEEB); // Sky blue (approx from screenshot) -> Actually Figma screenshot looks like primaryBlue or lighter. Let's use primaryBlue 0xFF6EC1F5 or similar if defined, else define here.
  // Using explicit color from screenshot (lightish blue for active track/thumb area glow)
  // Re-checking standard primary: 6EC1F5 is typical in this app.
  static const Color sliderTrackActive = Color(0xFF6EC1F5);
  static const Color sliderTrackInactive = Color(0xFFE5E7EB);
  static const Color sliderThumbColor = Color(0xFF6EC1F5);
  static const double sliderThumbRadius = 10.0;
  static const double sliderTrackHeight = 4.0;
  static const Color sliderValuePillBg =
      Color(0xFFEAF6FF); // Light blue bg for pill
  static const double sliderValuePillRadius = 12.0;
  static TextStyle get sheetSliderPillTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      );

  static TextStyle get sheetSliderLabelStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF6B7280),
      );

  // Checkbox
  static const double checkboxSize = 20.0;
  static const double checkboxRadius = 4.0;
  static const Color checkboxBorderColor = Color(0xFF6B7280);

  // Sticky Button
  // Assuming reusing generic PrimaryButton tokens but defining specific paddings
  static const double filterBottomBarHeight =
      84.0; // Height of the sticky container

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGES SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color messagesHeaderBg = Color(0xFFF3FAFD); // Same as screenBg
  static const Color messagesScreenBg = Color(0xFFFFFFFF); // White body
  static const Color messageRowDivider = Color(0xFFE4F4FC); // Soft divider
  static const Color messageNameColor = Color(0xFF1B2225); // textPrimary
  static const Color messagePreviewColor = Color(0xFF6B7680); // textSecondary
  static const Color messageTimeColor = Color(0xFF8A949C); // iconGrey
  static const Color unreadBadgeBg = Color(0xFF1F2B35); // Dark navy
  static const Color unreadBadgeText = Color(0xFFFFFFFF); // White
  static const Color verifiedBadgeBlue = Color(0xFF4FC3F7); // Light Blue check
  static const Color systemAvatarBg = Color(0xFFF3FAFD); // Pale blue bg

  // Layout
  static double get messageRowHorizontalPadding => 24.w;
  static double get messageRowVerticalPadding => 16.h;
  static double get messageAvatarSize => 48.w;
  static double get verifiedIconSize => 16.w;
  static double get unreadBadgeSize => 20.w;
  static double get messageDividerHeight => 1.0;
  static double get rowGapNameToPreview => 4.h;
  static double get trailingColumnWidth => 60.w;

  // Typography
  static TextStyle get messagesTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: appBarTitleGrey,
        height: 1.2,
      );

  static TextStyle get messageNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: messageNameColor,
        height: 1.2,
      );

  static TextStyle get messagePreviewStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: messagePreviewColor,
        height: 1.3,
      );

  static TextStyle get messageTimeStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: messageTimeColor,
        height: 1.0,
      );

  static TextStyle get unreadBadgeTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: unreadBadgeText,
        height: 1.0,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAT THREAD SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color chatHeaderBg = Color(0xFFF3FAFD); // Pale blue
  static const Color chatScreenBg = Color(0xFFFFFFFF); // White body/bg
  static const Color chatBubbleIncomingBg =
      Color(0xFFF3F4F6); // Soft grey/white
  static const Color chatBubbleOutgoingBg = Color(0xFF89CFF0); // Primary blue
  static const Color chatBubbleOutgoingText = Colors.white;
  static const Color chatMetaText = Color(0xFF9CA3AF); // Light grey timestamps
  static const Color chatDividerText = Color(0xFF9CA3AF); // "Today"
  static const Color callTileBg = Color(0xFFF0F9FF); // Very light blue tile
  static const Color composerBg = Color(0xFFF3FAFD); // Bottom area bg
  static const Color composerFieldBg = Colors.white;
  static const Color composerFieldBorder = Color(0xFFE5E7EB);
  static const Color composerPlaceholder = Color(0xFF9CA3AF);
  static const Color composerIconColor = Color(0xFF6B7280);
  static const Color sendButtonBg = Color(0xFF89CFF0);

  // Layout
  static double get chatHorizontalPadding => 24.w;
  static double get chatBubbleRadius => 16.r;
  static double get composerHeight => 80.h;
  static double get composerFieldHeight => 48.h;
  static double get composerRadius => 24.r;
  static double get sendButtonSize => 48.w;
  static double get bubbleMaxWidthFactor => 0.75; // 75% of screen width

  // Typography
  static TextStyle get chatSenderNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get chatMessageTextStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get chatMetaStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: chatMetaText,
        height: 1.2,
      );

  static TextStyle get callTileTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.2,
      );

  static TextStyle get callTileSubStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textSecondary,
        height: 1.2,
      );

  static TextStyle get composerHintStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: composerPlaceholder,
        height: 1.2,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // AUDIO CALL SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color callBg = Color(0xFFFFFFFF); // Base bg
  static const Color callHeaderText =
      Color(0xFF1B2225); // Dark text for title/name
  static const Color callControlBarBg = Color(0xFFF3FAFD); // Light pill bg
  static const Color callControlButtonBg = Color(
      0xFF6B7280); // Grey buttons (from visual) -> Actually screenshot shows grey circles
  static const Color callControlIconColor = Colors.white;
  static const Color callEndButtonBg = Color(0xFFEF4444); // Red
  static const Color callSubText = Color(0xFF6B7280); // Grey status/timer

  // Layout
  static double get callAvatarLargeSize => 120.w;
  static double get callAvatarMediumSize => 80.w;
  static double get callAvatarRadius => 100.r; // Circular
  static double get callControlsBarRadius => 32.r;
  static double get callControlsBarPadding => 8.w;
  static double get callControlsBarHeight => 80.h;
  static double get callControlsBarWidthFactor => 0.9;
  static double get callControlButtonSize => 56.w;
  static double get callControlIconSize => 24.w;
  static double get callEndButtonSize =>
      64.w; // Slightly larger usually, or same
  static double get callHorizontalPadding => 24.w;
  static double get callVerticalSpacingLg => 48.h;
  static double get callVerticalSpacingMd => 24.h;
  static double get callVerticalSpacingSm => 8.h;

  // Typography
  static TextStyle get callTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: callHeaderText,
        height: 1.2,
      );

  static TextStyle get callNameLargeStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: callHeaderText,
        height: 1.2,
      );

  static TextStyle get callNameMediumStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: callHeaderText,
        height: 1.2,
      );

  static TextStyle get callStatusStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: callSubText,
        height: 1.2,
      );

  static TextStyle get callTimerStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: callSubText,
        height: 1.2,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // VIDEO CALL SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color callOverlayText = Colors.white;
  static const Color callOverlayIcon = Colors.white;
  static const Color callControlBarBgVideo = Color(
      0xB3F3F4F6); // Translucent pinkish/white (0xB3 is ~70% opacity, F3F4F6 is light grey) - actually aiming for the subtle pinkish tone seen in screenshot. Let's try a bit warmer: 0xB3FFF0F5 or similar? Screenshot looks more like a blur with light tint. Let's stick to a safe translucent white/grey for now or match "pinkish" if user insisted. "Bar has translucent background tint (slight pinkish tone in screenshot)". Let's try Color(0xCCFFEEEE).
  static const Color pipBg = Colors.black; // Fallback
  static const Color pipShadowColor = Colors.black26;
  static const Color pipIconBg = Color(0x80FFFFFF); // Translucent white circle
  static const Color pipIconColor = Color(0xFF1B2225); // Dark grey

  // Layout
  static double get callTopBarVPadding => 8.h; // Plus safe area
  static double get callTopBarHPadding => 16.w;
  static double get callTopIconSize => 24.w;

  static double get pipWidth => 100.w;
  static double get pipHeight => 140.h; // Approx 3.5:5 ratio
  static double get pipRadius => 12.r;
  static double get pipMarginRight => 16.w;
  static double get pipMarginBottom =>
      16.h; // relative to control bar or bottom

  static double get pipInnerIconSize => 20.w;
  static double get pipInnerIconPadding => 4.w;

  // Typography for Video Call (White overlay)
  static TextStyle get callTopNameStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: callOverlayText,
        height: 1.2,
      );

  static TextStyle get callTopTimerStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500, // Slightly lighter than name
        color: callOverlayText,
        height: 1.2,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT CHAT SCREEN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color chatHeaderTitleColor = Color(0xFF1B2225);
  static const Color chatHeaderIconColor = Color(0xFF1B2225); // Dark grey/black
  static const Color chatSupportBadgeBg = Color(0xFF1B2225); // Black badge
  static const Color chatSupportBadgeIcon = Colors.white;

  static const Color supportBubbleBg = Colors.white;
  static const Color userBubbleBg =
      Color(0xFF7DD3FC); // Light blue similar to screenshot
  static const Color userBubbleText = Color(0xFF000000); // Dark text
  static const Color supportBubbleText = Color(0xFF374151); // Dark grey text

  static const Color chatMetaTextColor = Color(0xFF6B7280); // Grey 500
  static const Color chatDaySeparatorText = Color(0xFF9CA3AF); // Grey 400

  // Composer
  static const Color supportComposerBg = Color(0xFFF0F9FF); // Pale blue strip
  static const Color supportComposerFieldBg = Colors.white;
  static const Color supportComposerIconColor = Color(0xFF6B7280); // Grey
  static const Color supportSendBtnBg = Color(0xFF7DD3FC); // Blue
  static const Color supportSendBtnIcon = Colors.white;

  // Layout
  static double get supportAvatarSize => 40.w;
  static double get userAvatarSize => 40
      .w; // Actually screenshot has user avatar slightly overlap or sit effectively
  static double get supportBubbleRadius => 16.r;
  static double get supportBubbleMaxWidth => 0.75.sw;

  static double get chatHPadding => 16.w;
  static double get chatVPadding => 16.h;
  static double get bubblePadding => 12.w;

  // Typography
  static TextStyle get chatHeaderTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: chatHeaderTitleColor,
        height: 1.2,
      );

  static TextStyle get chatBubbleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: supportBubbleText, // Default
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // Colors
  static const Color dialogBg = Colors.white;
  static const Color dialogTitleColor = Color(0xFF1B2225); // Near black
  static const Color dialogBodyColor = Color(0xFF374151); // Dark grey text
  static const Color dialogDestructiveTextColor =
      Color(0xFF6B7280); // Gray (as per screenshot requirement)
  static const Color dialogPrimaryBtnBg = Color(0xFF7DD3FC); // Light blue
  static const Color dialogPrimaryBtnText = Colors.white;
  static const Color dialogCloseIconColor = Color(0xFF1B2225);

  // Layout
  static double get dialogRadius => 24.r; // Large radius
  static double get dialogPadding => 24.w; // Generous padding
  static double get dialogCloseIconSize => 20.w;
  static double get dialogPrimaryBtnHeight => 48.h;
  static double get dialogActionGap =>
      16.w; // Gap between actions if needed, though spaced between

  // Typography
  static TextStyle get dialogTitleStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp, // Large and bold
        fontWeight: FontWeight.w700,
        color: dialogTitleColor,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get dialogBodyStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.sp, // Readable body
        fontWeight: FontWeight.w400,
        color: dialogBodyColor,
        height: 1.5, // Airy line height
      );

  static TextStyle get dialogDestructiveActionStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: dialogDestructiveTextColor,
      );

  static TextStyle get dialogPrimaryBtnStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: dialogPrimaryBtnText,
      );
  // ═══════════════════════════════════════════════════════════════════════════
  // HELP & SUPPORT TOKENS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color heroBg = Color(0xFFD9F0FF); // Light pastel blue
  static const Color heroIconColor = Color(0xFF89CFF0); // Slightly darker blue
  static double get heroRadius => 24.r; // Rounded square
  static double get heroSize => 100.w; // Large hero size
  static double get heroIconSize => 48.w;

  static TextStyle get helpSupportHeaderStyle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );
}
