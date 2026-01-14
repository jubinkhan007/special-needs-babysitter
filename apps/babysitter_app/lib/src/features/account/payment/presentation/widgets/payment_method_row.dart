import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// A single payment method row with icon, title, and plus button.
class PaymentMethodRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback? onTap;

  const PaymentMethodRow({
    super.key,
    required this.leading,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: AppTokens.methodRowHeight.h,
        child: Row(
          children: [
            // Leading icon in circle
            Container(
              width: AppTokens.methodIconCircleSize.w,
              height: AppTokens.methodIconCircleSize.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTokens.methodIconCircleBorder,
                  width: 1,
                ),
              ),
              child: Center(child: leading),
            ),
            SizedBox(width: 16.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTokens.methodTitleStyle,
              ),
            ),
            // Plus icon
            Icon(
              Icons.add,
              size: AppTokens.methodPlusSize.sp,
              color: AppTokens.methodPlusColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget for text-based icons (like "VISA").
class TextIcon extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TextIcon({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1F71), // VISA blue
          ),
    );
  }
}

/// Helper widget for brand icons represented with IconData.
class BrandIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const BrandIcon({
    super.key,
    required this.icon,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: (size ?? 20).sp,
      color: color ?? const Color(0xFF6B7280),
    );
  }
}
