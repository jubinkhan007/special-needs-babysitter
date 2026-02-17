import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';
import '../models/review_ui_model.dart';
import 'star_row.dart';

/// A single review list item widget.
class ReviewListItem extends StatelessWidget {
  final ReviewUiModel model;

  const ReviewListItem({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTokens.reviewItemVerticalPadding.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: AppTokens.reviewAvatarSize.w,
                height: AppTokens.reviewAvatarSize.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTokens.avatarPlaceholderBg,
                  image: model.reviewerAvatarUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(model.reviewerAvatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: model.reviewerAvatarUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 20.sp,
                        color: Colors.white,
                      )
                    : null,
              ),

              SizedBox(width: 12.w),

              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.reviewerName,
                          style: AppTokens.reviewerNameStyle,
                        ),
                        Text(
                          model.timeAgoText,
                          style: AppTokens.reviewTimeAgoStyle,
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Stars
                    StarRow(rating: model.rating),

                    SizedBox(height: 8.h),

                    // Comment
                    Text(
                      model.comment,
                      style: AppTokens.reviewCommentStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(
            height: AppTokens.reviewItemDividerThickness,
            thickness: AppTokens.reviewItemDividerThickness,
            color: AppTokens.reviewItemDividerColor,
          ),
        ],
      ),
    );
  }
}
