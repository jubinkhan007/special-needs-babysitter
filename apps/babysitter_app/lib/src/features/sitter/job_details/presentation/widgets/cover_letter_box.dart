import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Cover letter text input area.
class CoverLetterBox extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CoverLetterBox({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppTokens.cardBorder,
            width: 1,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTokens.textPrimary,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: 'Write your cover letter',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
            ),
            contentPadding: EdgeInsets.all(16.w),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
