import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class FilterDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const FilterDropdownField({
    super.key,
    required this.hint,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppTokens.sheetFieldHeight,
        padding:
            const EdgeInsets.symmetric(horizontal: AppTokens.sheetFieldPadding),
        decoration: BoxDecoration(
          color: AppTokens.sheetFieldBg,
          borderRadius: BorderRadius.circular(AppTokens.sheetFieldRadius),
          border: Border.all(color: AppTokens.sheetFieldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hint,
              style: value != null
                  ? AppTokens.sheetFieldTextStyle
                  : AppTokens.sheetFieldHintStyle,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppTokens.sheetFieldIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
