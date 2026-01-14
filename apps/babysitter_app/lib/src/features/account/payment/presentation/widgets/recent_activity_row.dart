import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// A single recent activity row showing transaction details.
class RecentActivityRow extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String dateText;
  final String amountText;
  final VoidCallback? onTap;

  const RecentActivityRow({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.dateText,
    required this.amountText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: AppTokens.activityRowHeight.h,
        child: Row(
          children: [
            // Leading icon
            Icon(
              leadingIcon,
              size: AppTokens.activityLeadingIconSize.sp,
              color: AppTokens.activityLeadingIconColor,
            ),
            SizedBox(width: 16.w),
            // Title and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTokens.activityTitleStyle,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    dateText,
                    style: AppTokens.activityDateStyle,
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              amountText,
              style: AppTokens.activityAmountStyle,
            ),
          ],
        ),
      ),
    );
  }
}
