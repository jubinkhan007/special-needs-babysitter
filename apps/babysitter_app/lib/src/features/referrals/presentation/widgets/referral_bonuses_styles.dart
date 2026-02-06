import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class ReferralBonusesStyles {
  static const double horizontalPadding = 20;
  static const double cardPadding = 16;
  static const double cardRadius = 16;

  static const Color background = AppTokens.bg;
  static const Color cardBackground = AppTokens.surfaceWhite;
  static const Color textPrimary = AppTokens.textPrimary;
  static const Color textSecondary = AppTokens.textSecondary;
  static const Color iconGrey = AppTokens.iconGrey;

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: AppTokens.cardShadow,
      );

  static TextStyle get cardTitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 14,
        color: textSecondary,
        height: 1.4,
      );

  static TextStyle get sectionTitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get label => const TextStyle(
        fontSize: 13,
        color: textSecondary,
      );

  static TextStyle get value => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );
}
