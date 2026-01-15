import 'package:flutter/material.dart';

// Reusing same style as dropdown, but with specific layout/icons
import '../../../../../../theme/app_tokens.dart';

class FilterTextField extends StatelessWidget {
  final String hint;
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;

  const FilterTextField({
    super.key,
    required this.hint,
    this.value,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppTokens.sheetFieldHeight,
        padding: const EdgeInsets.only(
            left: AppTokens.sheetFieldPadding,
            right: 12), // slightly tighter on right for icon
        decoration: BoxDecoration(
          color: AppTokens.sheetFieldBg,
          borderRadius: BorderRadius.circular(AppTokens.sheetFieldRadius),
          border: Border.all(color: AppTokens.sheetFieldBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: value != null
                    ? AppTokens.sheetFieldTextStyle
                    : AppTokens.sheetFieldHintStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: AppTokens.sheetFieldIconColor,
              ),
          ],
        ),
      ),
    );
  }
}
