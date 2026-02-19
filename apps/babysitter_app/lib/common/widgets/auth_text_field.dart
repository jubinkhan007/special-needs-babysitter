import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable text field widget for auth screens
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.validator,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final labelColor =
        isDark ? colorScheme.onSurfaceVariant : AppColors.textPrimary.withOpacity(0.8);
    final textColor = isDark ? colorScheme.onSurface : AppColors.textPrimary;
    final hintColor =
        isDark ? colorScheme.onSurfaceVariant : AppColors.textPrimary.withOpacity(0.4);
    final fillColor = isDark ? colorScheme.surface : Colors.white;
    final borderColor = isDark ? colorScheme.outline : AppColors.inputBorder;
    final focusBorderColor =
        isDark ? colorScheme.primary : AppColors.secondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: _numericInputFormatters(keyboardType),
          textInputAction: textInputAction,
          style: TextStyle(
            fontSize: 15,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 15,
              color: hintColor,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusBorderColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1.5,
              ),
            ),
            suffixIcon: suffixIcon,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
