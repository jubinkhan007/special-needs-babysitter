import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class IssueTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String hintText;

  const IssueTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.hintText = 'Select Issue Type',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.formFieldBg,
        borderRadius: BorderRadius.circular(AppTokens.formFieldRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.formFieldPaddingX,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppTokens.formFieldBg,
          icon:
              const Icon(Icons.keyboard_arrow_down, color: AppTokens.iconGrey),
          hint: Text(hintText, style: AppTokens.formHintStyle),
          isExpanded: true,
          style: AppTokens.formTextStyle,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
