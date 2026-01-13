import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? optionalText;

  const SectionHeader({
    super.key,
    required this.title,
    this.optionalText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          fontSize:
              20, // Match main title size or slightly smaller? Figma: "Emergency Contact" looks ~20px like "Job Details"
          // Let's assume it's a section title. Step 1 had "Additional Details & Pay Rate" at 20px w700.
          fontWeight: FontWeight.w700,
          color: Color(0xFF101828),
          fontFamily: 'Instrument Sans', // or default
        ),
        children: [
          if (optionalText != null) ...[
            const TextSpan(text: ' '), // Space
            TextSpan(
              text: optionalText,
              style: const TextStyle(
                fontSize: 16, // Smaller than title
                fontWeight: FontWeight.w400, // Regular/Lighter
                color: Color(0xFF667085), // Grey 500
              ),
            ),
          ],
        ],
      ),
    );
  }
}
