import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// A row of stars representing a rating.
class StarRow extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  const StarRow({
    super.key,
    required this.rating,
    this.size = AppTokens.starsSize,
    this.filledColor = AppTokens.starFilledColor,
    this.emptyColor = AppTokens.starEmptyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        // Calculate fill for this star (0 to 1)
        // e.g. rating 4.5
        // index 0 -> 4.5 > 1 -> filled
        // index 3 -> 4.5 > 4 -> filled
        // index 4 -> 4.5 - 4 -> 0.5 (half) - For now we'll do simple full/empty or see if we need half
        // The requirements asked for "StarRow(rating: double)"
        // Screenshot shows filled yellow stars and empty grey stars.
        // It's safer to implement full/empty logic first unless half is explicitly shown in tokens (it wasn't specially requested but usually nice).
        // Let's stick to full/empty for simplicity unless we see half stars in screenshot.
        // Screenshot has 4.5 rating but visually all stars look filled in the small summary?
        // Wait, looking at screenshot items: "David M" has 5 stars. "Reema T" has 4 stars (last one empty).
        // So we definitly need empty stars.

        // Usually 4.5 rounds to 5? Or 4?
        // Let's use basic logic:
        // if index < rating (floor) -> filled
        // if index == rating (floor) && remainder > 0 -> half?
        // "Reema T" has 4 filled, 1 empty. Rating 4.0?
        // Let's assume standard behavior:
        // index starts at 0.
        // rating 4.0: 0,1,2,3 filled. 4 empty.

        IconData iconData = Icons.star_rounded;
        Color color = emptyColor;

        if (index < rating) {
          color = filledColor;
          // TODO: Add half star logic if needed, but standard material rounded star usually looks good as full.
        }

        return Padding(
          padding: EdgeInsets.only(right: AppTokens.starsGap.w),
          child: Icon(
            iconData,
            size: size.sp,
            color: color,
          ),
        );
      }),
    );
  }
}
