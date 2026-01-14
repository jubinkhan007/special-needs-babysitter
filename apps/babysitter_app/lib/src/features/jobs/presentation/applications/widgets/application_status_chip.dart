import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class ApplicationStatusChip extends StatelessWidget {
  const ApplicationStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTokens.applicationChipBg,
        borderRadius: BorderRadius.circular(100), // Pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppTokens.applicationChipDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Application',
            style: AppTokens.applicationChipTextStyle,
          ),
        ],
      ),
    );
  }
}
