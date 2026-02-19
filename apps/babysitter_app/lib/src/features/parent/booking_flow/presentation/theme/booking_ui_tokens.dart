import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BookingUiTokens {
  // Colors
  static const Color bottomSheetBg = Color(0xFFF3FBFF);
  static const Color primaryButtonBg = Color(0xFF89CFF2);
  static const Color noteCardText = Color(0xFF1B2225);
  static const Color dashedLineColor = Color(0xFFD7E6EE);

  static const Color pageBackground = AppColors.surfaceTint; // Main light blue bg
  static const Color primaryText = Color(0xFF08102A); // Big title
  static const Color valueText = Color(0xFF1B2225); // Right column amounts
  static const Color labelText =
      Color(0xFF6B7280); // Updated Left column labels
  static const Color topBarTitleGrey = Color(0xFF7A8186); // Updated
  static const Color iconGrey = Color(0xFF7A8186); // Updated
  static const Color dividerColor = Color(0xFFCDDBE1);
  static const Color noteCardBackground = Color(0xFFCFEAF6); // Updated
  static const Color linkBlue = Color(0xFF86D3F5); // Updated
  static const Color ctaButtonBackground = Color(0xFFB8E2F6);
  static const Color ctaButtonText = Color(0xFFFFFFFF);

  // Spacing
  static const double screenHorizontalPadding = 24.0;
  static const double noteCardRadius = 20.0;
  static const double ctaButtonRadius = 14.0;
  static const double ctaButtonHeight = 52.0;

  // Text Styles
  static const TextStyle topBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: topBarTitleGrey,
    fontFamily: 'Instrument Sans', // Consistently using app font
  );

  static const TextStyle pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: primaryText,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle rowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: labelText,
  );

  static const TextStyle rowValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: valueText,
  );

  static const TextStyle totalValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: valueText,
    letterSpacing: -0.5,
  );

  static const TextStyle noteTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: valueText,
  );

  static const TextStyle noteBody = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: valueText,
    height: 1.4,
  );

  static const TextStyle noteLink = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: linkBlue,
    decoration: TextDecoration.underline,
    decorationColor: linkBlue,
  );

  static const TextStyle ctaText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: ctaButtonText,
  );

  static const TextStyle addMethodLink = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: valueText,
    decoration: TextDecoration.underline,
  );

  // --- Payment Method Selection Tokens ---
  static const Color itemTitleText = Color(0xFF1B2225);
  static const Color itemSubtitleText = Color(0xFF6B7280);
  static const Color radioOuterGrey = Color(0xFF8B949A);
  static const Color radioSelectedOuterBlue = Color(0xFF7CC9EE);
  static const Color radioSelectedInnerBlue = Color(0xFF7CC9EE);
  static const Color iconCircleBg = Color(0xFFEAF6FB);
  static const Color logoCircleBgWhite = Color(0xFFFFFFFF);
  static const Color listChevronGrey = Color(0xFF7A8186);

  static const TextStyle modalTopBarTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: topBarTitleGrey,
    fontFamily: 'Instrument Sans',
  );

  static const TextStyle selectionPageTitle = TextStyle(
    fontSize: 32, // Matching screen title "Select Payment Method"
    fontWeight: FontWeight.w800,
    color: primaryText,
    height: 1.05,
    letterSpacing: -1.0,
  );

  static const TextStyle itemTitle = TextStyle(
    fontSize: 16, // Reduced from 20
    fontWeight: FontWeight.w700,
    color: itemTitleText,
  );

  static const TextStyle itemSubtitle = TextStyle(
    fontSize: 13, // Reduced from 14
    fontWeight: FontWeight.w400,
    color: itemSubtitleText,
    height: 1.3,
  );

  static const double iconDiscSize = 48.0; // Reduced from 56
  static const double radioSize = 20.0; // Reduced from 24

  // --- Success Screen Tokens ---
  static const TextStyle successTitle = TextStyle(
    fontSize:
        32, // Prompt said 40-44, but we reduced everything else. Let's stick to proportionate scale, maybe 32 is huge enough compared to 24 pageTitle.
    fontWeight: FontWeight.w800,
    color: Color(0xFF1B2225),
    height: 1.05,
    letterSpacing: -1.0,
  );

  static const TextStyle successBody = TextStyle(
    fontSize: 18, // Reduced from 22-24 to match scale
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
    height: 1.35,
  );

  static const TextStyle secondaryCtaText = TextStyle(
    fontSize: 18, // Reduced from 24-26
    fontWeight: FontWeight.w700,
    color: Color(0xFF7A8186),
  );
}
