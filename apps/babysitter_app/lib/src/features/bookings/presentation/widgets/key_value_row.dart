import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal; // Special style for Total Cost

  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // Spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, // Label takes less space
            child: Text(
              label,
              style: isTotal ? AppTokens.totalCostLabel : AppTokens.detailKey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3, // Value takes more space
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: isTotal ? AppTokens.totalCostValue : AppTokens.detailValue,
            ),
          ),
        ],
      ),
    );
  }
}
