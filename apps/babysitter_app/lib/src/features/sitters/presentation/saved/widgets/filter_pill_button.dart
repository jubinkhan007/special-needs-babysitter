import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// Filter pill button with dropdown chevron.
class FilterPillButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FilterPillButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppTokens.filterPillHeight.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppTokens.filterPillBg,
          borderRadius: BorderRadius.circular(AppTokens.filterPillRadius.r),
          border: Border.all(
            color: AppTokens.filterPillBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter By:',
              style: AppTokens.filterPillTextStyle,
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.sp,
              color: AppTokens.filterPillIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
