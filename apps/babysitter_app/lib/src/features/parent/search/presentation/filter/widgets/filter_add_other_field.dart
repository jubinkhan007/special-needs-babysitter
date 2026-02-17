import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class FilterAddOtherField extends StatelessWidget {
  final VoidCallback onTap;
  final String? value;

  const FilterAddOtherField({
    super.key,
    required this.onTap,
    this.value,
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
              value ?? 'Add Other',
              style: value != null
                  ? AppTokens.sheetFieldTextStyle
                  : AppTokens.sheetFieldHintStyle,
            ),
            const Icon(
              Icons.add,
              size: 20,
              color: AppTokens.sheetFieldIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
