import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

/// A highlight item with bold title and normal description.
/// Used in About screen for key highlights section.
class HighlightItem extends StatelessWidget {
  final String titleBold;
  final String description;

  const HighlightItem({
    super.key,
    required this.titleBold,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 15.sp,
            height: 1.5,
            color: AppTokens.textSecondary,
          ),
          children: [
            TextSpan(
              text: '$titleBold ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTokens.textPrimary,
              ),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }
}
