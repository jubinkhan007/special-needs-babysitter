// rating_row.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  const RatingRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          return Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppTokens.starYellow,
            size: 20,
          );
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: AppTokens.statLabel.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTokens.textPrimary,
          ),
        ),
      ],
    );
  }
}
