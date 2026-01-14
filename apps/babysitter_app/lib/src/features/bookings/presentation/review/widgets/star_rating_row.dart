import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class StarRatingRow extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final double iconSize;

  const StarRatingRow({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.iconSize = 32, // Distinct size for review screen
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= rating;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.star_rounded,
              size: iconSize,
              color: isSelected ? AppTokens.starYellow : AppTokens.iconGrey,
            ),
          ),
        );
      }),
    );
  }
}
