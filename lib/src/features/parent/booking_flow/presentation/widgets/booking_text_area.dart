import 'package:flutter/material.dart';

class BookingTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const BookingTextArea({
    super.key,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Large fixed height per screenshot
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFB2DDFF)), // Light Blue (Blue 200 roughly)
      ),
      child: TextField(
        controller: controller,
        maxLines: null, // Multiline
        expands: true,
        textAlignVertical: TextAlignVertical.top, // Start top left
        style: const TextStyle(color: Color(0xFF101828)), // Input text color
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // Force white bg
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF667085), // Grey 500
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
