import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBoldValue;

  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.isBoldValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF667085), // Label grey text
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFF101828), // Darker/bolder text
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
