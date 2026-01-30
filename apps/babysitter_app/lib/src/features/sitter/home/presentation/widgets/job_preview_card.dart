import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/job_preview.dart';
import 'app_tag_chip.dart';

/// Job preview card for sitter home screen.
class JobPreviewCard extends StatelessWidget {
  final JobPreview job;
  final VoidCallback? onViewDetails;
  final VoidCallback? onBookmark;

  const JobPreviewCard({
    super.key,
    required this.job,
    this.onViewDetails,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20.w, vertical: 8.h), // Tight vertical spacing
      padding: EdgeInsets.all(16.w), // Balanced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r), // Softer radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Very subtle shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
            color: const Color(0xFFEAECF0), width: 1), // Light border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          _buildTitleRow(),
          SizedBox(height: 10.h),
          // Family Row
          _buildFamilyRow(),
          SizedBox(height: 6.h),
          // Children Row
          _buildChildrenRow(),
          SizedBox(height: 6.h),
          // Location Row
          _buildLocationRow(),
          SizedBox(height: 12.h),
          // Tags Row
          _buildTagsRow(),
          SizedBox(height: 12.h),
          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF2F4F7), // Ultra light divider
          ),
          SizedBox(height: 12.h),
          // Bottom Row
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            job.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101828), // Dark shade
              fontFamily: 'Inter',
            ),
          ),
        ),
        GestureDetector(
          onTap: onBookmark,
          child: Icon(
            job.isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
            size: 22.w,
            color: const Color(0xFF667085), // Grey icon
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyRow() {
    return Row(
      children: [
        if (job.familyAvatarUrl != null && job.familyAvatarUrl!.isNotEmpty)
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: job.familyAvatarUrl!,
              width: 24.w,
              height: 24.w,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => _buildPlaceholderAvatar(),
              placeholder: (context, url) => _buildPlaceholderAvatar(),
            ),
          )
        else
          _buildPlaceholderAvatar(),
        SizedBox(width: 8.w),
        Text(
          job.familyName,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF344054),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '(${job.childrenCount} Children)',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.secondary, // Blue
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.child_care_rounded,
            size: 16.w, color: const Color(0xFF98A2B3)),
        SizedBox(width: 8.w),
        Expanded(
          child: Wrap(
            children: job.children.asMap().entries.map((entry) {
              final isLast = entry.key == job.children.length - 1;
              final child = entry.value;
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: child.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF475467),
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: ' (${child.age} Years)',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.secondary, // Blue
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (!isLast)
                      TextSpan(
                        text: ' | ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFD0D5DD),
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined,
            size: 16.w, color: const Color(0xFF98A2B3)),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: job.location, // e.g. Brooklyn, NY 11201
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF475467),
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: ' (${job.distance})',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.secondary, // Blue
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children:
          job.requiredSkills.map((skill) => AppTagChip(label: skill)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$${job.hourlyRate.toInt()}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101828),
                  fontFamily: 'Inter',
                ),
              ),
              TextSpan(
                text: '/hr',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // View Details
        GestureDetector(
          onTap: onViewDetails,
          child: Text(
            'View Details',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.group,
        size: 14.w,
        color: const Color(0xFF667085),
      ),
    );
  }
}
