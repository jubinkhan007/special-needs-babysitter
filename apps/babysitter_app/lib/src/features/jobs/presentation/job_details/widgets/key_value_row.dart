import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiline; // Renamed from isAddress for generic use

  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTokens.jobDetailsLabelStyle,
            ),
          ),
          // Value
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: AppTokens.jobDetailsValueStyle,
                maxLines: isMultiline ? 4 : 1, // Address/Notes can wrap
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
