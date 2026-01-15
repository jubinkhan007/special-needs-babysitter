import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class FilterCheckboxRow extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const FilterCheckboxRow({
    super.key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => onChanged(!isChecked),
        borderRadius: BorderRadius.circular(4),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Allows tapping row
          children: [
            // Custom checkbox look to match Figma
            Container(
              width: AppTokens.checkboxSize,
              height: AppTokens.checkboxSize,
              decoration: BoxDecoration(
                color: isChecked ? AppTokens.sliderThumbColor : Colors.white,
                borderRadius: BorderRadius.circular(AppTokens.checkboxRadius),
                border: Border.all(
                  color: isChecked
                      ? AppTokens.sliderThumbColor
                      : AppTokens.checkboxBorderColor,
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTokens.sheetCheckboxTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
