import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';
import '../models/saved_sitter_ui_model.dart';

/// Card widget for displaying a saved sitter.
class SavedSitterCard extends StatelessWidget {
  final SavedSitterUiModel sitter;
  final VoidCallback? onViewProfile;
  final VoidCallback? onBookmarkTap;

  const SavedSitterCard({
    super.key,
    required this.sitter,
    this.onViewProfile,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTokens.savedCardBg,
        borderRadius: BorderRadius.circular(AppTokens.savedCardRadius.r),
        border: Border.all(
          color: AppTokens.savedCardBorder,
          width: 1,
        ),
        boxShadow: AppTokens.savedCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Avatar, Name/Location, Rating, Bookmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24.r,
                backgroundImage: sitter.avatarUrl.isNotEmpty
                    ? NetworkImage(sitter.avatarUrl)
                    : const AssetImage('assets/images/user1.png')
                        as ImageProvider,
              ),
              SizedBox(width: 12.w),
              // Name + Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sitter.name,
                          style: AppTokens.savedSitterNameStyle,
                        ),
                        if (sitter.isVerified) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.verified,
                            size: 16.sp,
                            color: AppTokens.viewProfileButtonBg,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: AppTokens.savedSitterLocationStyle.color,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          sitter.location,
                          style: AppTokens.savedSitterLocationStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16.sp,
                    color: AppTokens.ratingStarColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    sitter.ratingText,
                    style: AppTokens.savedRatingTextStyle,
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              // Bookmark
              GestureDetector(
                onTap: onBookmarkTap,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppTokens.bookmarkContainerBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: AppTokens.bookmarkContainerBorder,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    sitter.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 18.sp,
                    color: AppTokens.bookmarkIconColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Stats row
          Row(
            children: [
              _StatItem(
                icon: Icons.access_time_outlined,
                label: 'Response Rate',
                value: sitter.responseRateText,
              ),
              SizedBox(width: 16.w),
              _StatItem(
                icon: Icons.thumb_up_alt_outlined,
                label: 'Reliability Rate:',
                value: sitter.reliabilityRateText,
              ),
              SizedBox(width: 16.w),
              _StatItem(
                icon: Icons.work_outline,
                label: 'Experience',
                value: sitter.experienceText,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Skill tags
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: sitter.skills.map((skill) => _SkillTag(skill)).toList(),
          ),

          SizedBox(height: 16.h),

          // Bottom row: Price + View Profile button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    sitter.priceDollarAmount,
                    style: AppTokens.savedPriceBigStyle,
                  ),
                  Text(
                    sitter.priceSuffix,
                    style: AppTokens.savedPriceSuffixStyle,
                  ),
                ],
              ),
              // View Profile button
              GestureDetector(
                onTap: onViewProfile,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppTokens.viewProfileButtonBg,
                    borderRadius: BorderRadius.circular(
                        AppTokens.viewProfileButtonRadius.r),
                  ),
                  child: Text(
                    'View Profile',
                    style: AppTokens.viewProfileButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stat item widget for response rate, reliability, experience.
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: AppTokens.savedStatLabelStyle.color,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  label,
                  style: AppTokens.savedStatLabelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTokens.savedStatValueStyle,
          ),
        ],
      ),
    );
  }
}

/// Skill tag pill widget.
class _SkillTag extends StatelessWidget {
  final String text;

  const _SkillTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.skillTagHorizontalPadding.w,
        vertical: AppTokens.skillTagVerticalPadding.h,
      ),
      decoration: BoxDecoration(
        color: AppTokens.skillTagBg,
        borderRadius: BorderRadius.circular(AppTokens.skillTagRadius.r),
      ),
      child: Text(
        text,
        style: AppTokens.skillTagStyle,
      ),
    );
  }
}
