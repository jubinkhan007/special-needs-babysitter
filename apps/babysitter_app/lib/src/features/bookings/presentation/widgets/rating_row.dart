import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class RatingRow extends StatelessWidget {
  final double rating;

  const RatingRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < 4) {
            return const Icon(Icons.star_rounded,
                color: AppTokens.starYellow, size: 24);
          }
          return const Icon(Icons.star_border_rounded,
              color: AppTokens.starYellow, size: 24);
        }),
        const SizedBox(width: 8),
        Text(
          rating.toString(),
          style: AppTokens.statValue.copyWith(
              fontSize: 18), // Slightly adjusted per card implementation
        ),
      ],
    );
  }
}
