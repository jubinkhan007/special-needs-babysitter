import 'package:flutter/material.dart';

class SummaryKvRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;
  final int? maxLines;
  final CrossAxisAlignment valueAlignment;

  const SummaryKvRow({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
    this.maxLines,
    this.valueAlignment = CrossAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 130, // Fixed width for labels to align vertically
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085), // Grey 500
              ),
            ),
          ),

          // Value
          Expanded(
            child: Column(
              crossAxisAlignment: valueAlignment,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600, // Semibold for value
                    color: Color(0xFF101828), // Dark text
                    height: 1.5, // Line height for multi-line text
                  ),
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Edit Icon
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: Color(0xFF98A2B3), // Lighter grey for icon
            ),
          ),
        ],
      ),
    );
  }
}
