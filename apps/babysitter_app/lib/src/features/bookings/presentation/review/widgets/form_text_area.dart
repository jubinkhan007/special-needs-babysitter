import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class FormTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const FormTextArea({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 6,
    this.onChanged,
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
        vertical: AppTokens.formFieldPaddingY,
      ),
      child: TextField(
        controller: controller, // Controller must be passed
        maxLines: maxLines,
        style: AppTokens.formTextStyle,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTokens.formHintStyle,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          filled: false,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}
