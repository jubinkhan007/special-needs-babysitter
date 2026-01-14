import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class JobStatusChip extends StatelessWidget {
  final bool isActive;

  const JobStatusChip({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink(); // Or generic 'Closed' chip

    return Container(
      height: AppTokens.jobChipHeight,
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.jobChipHorizontalPadding),
      decoration: BoxDecoration(
        color: AppTokens.jobChipBgActive,
        borderRadius: BorderRadius.circular(AppTokens.jobChipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTokens.jobChipDotActive,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Active',
            style: AppTokens.jobChipTextStyle,
          ),
        ],
      ),
    );
  }
}
