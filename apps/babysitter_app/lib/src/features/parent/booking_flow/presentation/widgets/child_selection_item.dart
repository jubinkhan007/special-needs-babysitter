import 'package:flutter/material.dart';
import '../../data/models/child_ui_model.dart';

class ChildSelectionItem extends StatelessWidget {
  final ChildUiModel child;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const ChildSelectionItem({
    super.key,
    required this.child,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 12), // Increased vertical spacing per Figma
        child: Row(
          children: [
            // Checkbox (Custom to match visuals)
            Container(
              width:
                  24, // Matches Figma checkbox size typically 24 or 20. Let's go 24 for touch.
              height: 24,
              decoration: BoxDecoration(
                color: child.isSelected
                    ? const Color(0xFF2E90FA) // Blue 600
                    : Colors.transparent,
                border: Border.all(
                  color: child.isSelected
                      ? const Color(0xFF2E90FA)
                      : const Color(0xFF98A2B3), // Darker Grey (Grey 400)
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6), // Slightly rounder
              ),
              child: child.isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16), // Spacing
            // Name + Age
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Bold
                      color: Color(0xFF101828), // Gray 900
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    child.ageText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667085), // Gray 500
                    ),
                  ),
                ],
              ),
            ),
            // Edit Pencil
            GestureDetector(
              onTap: onEdit,
              child: const Padding(
                padding: EdgeInsets.all(4.0), // Touch target
                child: Icon(
                  Icons.mode_edit_outlined,
                  size: 20,
                  color: Color(0xFF98A2B3), // Lighter grey for icon
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
