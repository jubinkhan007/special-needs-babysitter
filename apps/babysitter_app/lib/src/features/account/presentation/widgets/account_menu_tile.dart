import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';

/// Reusable menu tile for the Account screen menu list.
class AccountMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const AccountMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppTokens.accountMenuTileHeight.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppTokens.accountCardBg,
          borderRadius:
              BorderRadius.circular(AppTokens.accountMenuTileRadius.r),
          border: Border.all(
            color: AppTokens.accountMenuBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: AppTokens.accountIconGrey,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTokens.accountMenuTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
