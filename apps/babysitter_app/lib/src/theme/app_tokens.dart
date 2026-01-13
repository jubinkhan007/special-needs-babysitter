import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTokens {
  AppTokens._();

  // --- Colors (Figma Exact - No Change) ---
  static const Color bg = Color(0xFFD8EFFA);
  static const Color appBarBg = bg;
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFD6ECF7);
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.05);

  static const Color textPrimary = Color(0xFF0B1B2B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color iconGrey = Color(0xFF7A8699);

  static const Color primaryBlue = Color(0xFF8FD3F4);
  static const Color darkButtonBg = Color(0xFF1F2A37);

  static const Color starYellow = Color(0xFFF9C941);

  // Status Chip Colors
  static const Color chipBlueBg = Color(0xFFD9F0FF);
  static const Color chipBlueDot = Color(0xFF6EC1F5);

  static const Color chipGreenBg = Color(0xFFDFF7E6);
  static const Color chipGreenDot = Color(0xFF34C759);

  static const Color chipOrangeBg = Color(0xFFFFE9CC);
  static const Color chipOrangeDot = Color(0xFFFF9500);

  static const Color chipGreyBg = Color(0xFFECEFF4);
  static const Color chipGreyDot = Color(0xFF8E8E93);

  // --- Dimensions & Spacing (Scaled) ---
  static double get screenHorizontalPadding => 16.w;
  static double get appBarHeight => 72.h; // Height scaling might need .h
  static double get tabsVerticalPadding => 12.h;

  static double get cardRadius => 16.r;
  static double get cardInternalPadding =>
      16.w; // Or .r for uniform padding? Usually .w or .r
  static double get cardVerticalGap => 12.h;

  static double get buttonRadius => 14.r;
  static double get buttonHeight => 56.h;
  static double get buttonSpacing => 12.h;

  static double get avatarSize => 56.w; // Square, use w for both or r

  // --- Typography (Scaled) ---
  static TextStyle get appBarTitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      );

  static TextStyle get cardName => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get cardMeta => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      );

  static TextStyle get statLabel => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      );

  static TextStyle get statValue => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get scheduledText => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get chipText => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get buttonText => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  static TextStyle get tabSelected => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get tabUnselected => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      );
}
