import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class WalletStyles {
  static const double horizontalPadding = 24;
  static const double cardPadding = 16;

  static const Color background = AppTokens.bg;
  static const Color textPrimary = AppTokens.textPrimary;
  static const Color textSecondary = AppTokens.textSecondary;
  static const Color iconGrey = AppTokens.iconGrey;
  static const Color primaryBlue = AppTokens.primaryBlue;

  static BoxDecoration cardDecoration({bool bordered = false}) => BoxDecoration(
        color: AppTokens.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        boxShadow: AppTokens.cardShadow,
        border: bordered ? Border.all(color: AppTokens.cardBorder) : null,
      );
}
