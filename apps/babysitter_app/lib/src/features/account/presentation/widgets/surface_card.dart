import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';

/// Reusable surface card wrapper with white background, rounded corners, and soft shadow.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.accountCardBg,
        borderRadius:
            BorderRadius.circular((radius ?? AppTokens.accountCardRadius).r),
        border: Border.all(
          color: AppTokens.accountCardBorder,
          width: 1,
        ),
        boxShadow: AppTokens.accountCardShadow,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppTokens.accountCardInternalPad.w),
        child: child,
      ),
    );
  }
}
