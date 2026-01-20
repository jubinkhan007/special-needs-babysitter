import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

/// Reusable search field widget.
class AppSearchField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final bool enabled;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.onTap,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 18.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                hintText,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textMuted,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
