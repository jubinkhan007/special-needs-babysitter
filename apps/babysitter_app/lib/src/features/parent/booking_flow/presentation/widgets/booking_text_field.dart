import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_field_card.dart';

class BookingTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const BookingTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
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
    return FormFieldCard(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            inputFormatters ?? _numericInputFormatters(keyboardType),
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
