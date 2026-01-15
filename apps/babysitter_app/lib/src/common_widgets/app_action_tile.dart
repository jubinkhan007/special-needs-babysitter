import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class AppActionTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsetsGeometry? padding;

  const AppActionTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.onTap,
    this.showChevron = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.cardBg,
        borderRadius: BorderRadius.circular(AppTokens
            .cardRadius), // Reuse card radius if specific token not needed
        border: Border.all(color: AppTokens.cardBorder),
        // No shadow per requirements
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
            child: Row(
              children: [
                // Icon wrapper to ensure consistent sizing/alignment if needed,
                // but user said "Icon centered with padding" for hero, here just "Icon on left".
                // We'll let leadingIcon define its own size or wrap it constraint.
                leadingIcon,
                SizedBox(width: 16.w), // Gap
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                ),
                if (showChevron)
                  Icon(
                    Icons.chevron_right,
                    color: AppTokens.iconGrey,
                    size: 24.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
