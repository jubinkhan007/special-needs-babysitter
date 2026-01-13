import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTokens.iconGrey),
            const SizedBox(width: 8),
            Text(label, style: AppTokens.statLabel),
          ],
        ),
        Text(value, style: AppTokens.statValue),
      ],
    );
  }
}
