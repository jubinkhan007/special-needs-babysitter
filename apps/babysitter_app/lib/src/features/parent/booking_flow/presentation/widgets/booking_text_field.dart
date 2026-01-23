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
    return FormFieldCard(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            inputFormatters ?? _numericInputFormatters(keyboardType),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // Force white bg
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF667085), // Grey 500
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF101828), // Dark Text
        ),
      ),
    );
  }
}
