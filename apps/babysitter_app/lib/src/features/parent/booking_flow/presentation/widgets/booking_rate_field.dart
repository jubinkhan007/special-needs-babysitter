import 'package:flutter/material.dart';

class BookingRateField extends StatelessWidget {
  final String value;

  const BookingRateField({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB2DDFF)), // Light Blue
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // SemiBold
          color: Color(0xFF101828), // Gray 900
        ),
      ),
    );
  }
}
