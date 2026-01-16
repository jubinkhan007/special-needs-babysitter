import 'package:flutter/material.dart';

class BookingRateField extends StatelessWidget {
  final String value;
  final ValueChanged<String>? onChanged;

  const BookingRateField({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Extract just the number from value like "$ 20/hr"
    final numericValue = value.replaceAll(RegExp(r'[^\d.]'), '');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB2DDFF)),
      ),
      child: TextField(
        controller: TextEditingController(text: numericValue),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF101828),
        ),
        decoration: const InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          prefixText: '\$ ',
          prefixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101828),
          ),
          suffixText: '/hr',
          suffixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF667085),
          ),
          hintText: '0',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}
