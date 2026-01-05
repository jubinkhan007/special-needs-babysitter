import 'package:flutter/material.dart';

/// Application color palette (aligned to onboarding screens + exported neutrals)
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Neutral palette (from your exported design-tokens.json)
  // ---------------------------------------------------------------------------
  static const Color neutral10 = Color(0xFFE2E2E2);
  static const Color neutral20 = Color(0xFFB6B6B6);
  static const Color neutral30 = Color(0xFF8B8B8B);
  static const Color neutral40 = Color(0xFF636363);
  static const Color neutral50 = Color(0xFF3E3E3E);
  static const Color neutral60 = Color(0xFF1B1B1B);

  // A mid neutral used in the token file (“source”)
  static const Color neutralSource = Color(0xFF444444);

  // ---------------------------------------------------------------------------
  // Brand (sampled from the onboarding screens you shared)
  // NOTE: replace these with exact values once you export brand colors from Figma.
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF89CFEF); // outline/link blue
  static const Color primarySoft = Color(0xFFAAD8ED); // filled CTA blue
  static const Color secondary = Color(0xFF4090B8); // deeper blue accents

  // ---------------------------------------------------------------------------
  // Surfaces / backgrounds (match the light-blue app background + white cards)
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFE6F4FB); // pale blue scaffold bg
  static const Color surface = Color(0xFFFFFFFF); // cards/sheets
  static const Color border = Color(0xFFDCEAF3); // soft blue-tinted border
  static const Color divider = border;

  // ---------------------------------------------------------------------------
  // Text (closer to the screenshot than slate indigo)
  // ---------------------------------------------------------------------------
  static const Color textPrimary = neutral60;
  static const Color textSecondary = neutral40;
  static const Color textMuted = neutral30;
  static const Color textTertiary = textMuted;

  // Inputs
  static const Color inputFill = surface;
  static const Color inputBorder = border;

  // ---------------------------------------------------------------------------
  // Status (sampled feel from “Upcoming” chip style)
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF44E462);
  static const Color successSoft = Color(0xFFD9F9DF);

  static const Color warning =
      Color(0xFFF59E0B); // placeholder (update if Figma has it)
  static const Color error = Color(0xFFEF4444); // placeholder
  static const Color info = Color(0xFF3B82F6); // placeholder

  // ---------------------------------------------------------------------------
  // Dark theme (reasonable mapping; adjust later if you design dark mode)
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0B0F14);
  static const Color darkSurface = neutral50;
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = neutral20;
  static const Color darkInputFill = neutral50;
  static const Color darkInputBorder = neutral40;
  static const Color darkDivider = neutral50;
}
