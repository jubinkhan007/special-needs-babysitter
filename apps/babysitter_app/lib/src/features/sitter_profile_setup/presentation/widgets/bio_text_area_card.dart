import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core/src/theme/app_typography.dart';

class BioTextAreaCard extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final int maxChars;

  const BioTextAreaCard({
    super.key,
    required this.text,
    required this.onChanged,
    this.maxChars = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Icon + Title
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceTint, // Light blue bg
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined, // Looks like list/doc icon
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Bio',
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w700,
                fontSize: 20, // Adjust to match visual
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Text Area
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.transparent), // No border in design? Or subtle?
            // Assuming no border, just shadow or flat white on blue bg.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                initialValue: text,
                onChanged: onChanged,
                maxLines: 6,
                maxLength: maxChars, // Enforce length
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) =>
                    null, // Hide default counter
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF1A1A1A),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Tell us about yourself.',
                  hintStyle: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              // Character Count
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Character Count: ${text.length} / $maxChars',
                    style: const TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
