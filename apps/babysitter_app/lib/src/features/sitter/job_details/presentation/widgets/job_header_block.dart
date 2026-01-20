import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Job header block with title, posted time, and bookmark icon.
class JobHeaderBlock extends StatelessWidget {
  final String title;
  final String postedTimeAgo;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const JobHeaderBlock({
    super.key,
    required this.title,
    required this.postedTimeAgo,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                    fontFamily: 'Inter',
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  postedTimeAgo,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTokens.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Bookmark icon
          GestureDetector(
            onTap: onBookmarkTap,
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                size: 24.w,
                color: AppTokens.iconGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
