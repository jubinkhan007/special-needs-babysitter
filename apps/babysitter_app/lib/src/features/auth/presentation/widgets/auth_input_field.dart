import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/core.dart';

/// Pixel-perfect input field matching Figma design
/// - Placeholder only (no external label)
/// - Light border, moderate radius (8px, not pill)
/// - Consistent padding
class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final String? helperText;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.helperText,
  });

  List<TextInputFormatter>? _numericInputFormatters(
      TextInputType? keyboardType) {
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: _numericInputFormatters(keyboardType),
      textInputAction: textInputAction,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null, // Hide counter
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        helperText: helperText,
        helperStyle: TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary.withOpacity(0.5),
        ),
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary.withOpacity(0.35),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Moderate radius, not pill
          borderSide: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
