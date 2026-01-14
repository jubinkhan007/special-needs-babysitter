import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class BookingSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BookingSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppTokens.cardInternalPadding),
      decoration: BoxDecoration(
        color: AppTokens.bookingDetailsCardBg,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        boxShadow: AppTokens.cardShadow,
        border: Border.all(color: AppTokens.cardBorder),
      ),
      child: child,
    );
  }
}
