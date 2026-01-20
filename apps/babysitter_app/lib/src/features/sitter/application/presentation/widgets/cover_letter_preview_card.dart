import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

import '../../../../../theme/app_tokens.dart';
import 'application_preview_card.dart';

/// Card 2 - Cover Letter Preview Card.
class CoverLetterPreviewCard extends StatelessWidget {
  final String coverLetter;

  const CoverLetterPreviewCard({
    super.key,
    required this.coverLetter,
  });

  @override
  Widget build(BuildContext context) {
    return ApplicationPreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon container
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppTokens.bg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 18.w,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: 8.w),
              // Title
              Text(
                'Cover Letter',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Cover letter text
          Text(
            coverLetter,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
