import 'package:flutter/material.dart';
import 'form_field_card.dart';

class BookingTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const BookingTextField({
    super.key,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      child: TextField(
        controller: controller,
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
