import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTagChip extends StatelessWidget {
  final String label;

  const AppTagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 10.w, vertical: 4.h), // Compact padding
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7), // Light gray-blue bg
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFF344054), // Dark gray text
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
