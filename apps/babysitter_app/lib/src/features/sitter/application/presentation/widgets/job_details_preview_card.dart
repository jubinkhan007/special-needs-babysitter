import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

import '../../../../../theme/app_tokens.dart';
import '../../../job_details/domain/entities/sitter_job_details.dart';
import '../../../home/presentation/widgets/app_tag_chip.dart';
import 'application_preview_card.dart';

/// Card 1 - Job Details Preview Card.
class JobDetailsPreviewCard extends StatelessWidget {
  final SitterJobDetails jobDetails;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const JobDetailsPreviewCard({
    super.key,
    required this.jobDetails,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return ApplicationPreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          _buildHeader(),
          SizedBox(height: 12.h),
          // Job title
          Text(
            jobDetails.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12.h),
          // Meta rows
          _buildMetaRows(),
          SizedBox(height: 12.h),
          // Skill chips
          if (jobDetails.requiredSkills.isNotEmpty) ...[
            _buildSkillChips(),
            SizedBox(height: 16.h),
          ],
          // Divider
          const Divider(height: 1, thickness: 1, color: AppTokens.dividerSoft),
          SizedBox(height: 16.h),
          // Service details table
          _buildServiceDetailsTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            Icons.work_outline,
            size: 18.w,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: 8.w),
        // Title
        Expanded(
          child: Text(
            'Job Details',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ),
        // Bookmark icon
        GestureDetector(
          onTap: onBookmarkTap,
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 20.w,
            color: AppTokens.iconGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRows() {
    return Column(
      children: [
        // Family row
        _buildMetaRow(
          icon: _buildFamilyAvatar(),
          child: _buildFamilyText(),
        ),
        SizedBox(height: 6.h),
        // Children row
        _buildMetaRow(
          icon: Icon(Icons.child_care, size: 14.w, color: AppTokens.iconGrey),
          child: _buildChildrenText(),
        ),
        SizedBox(height: 6.h),
        // Location row
        _buildMetaRow(
          icon: Icon(Icons.location_on_outlined,
              size: 14.w, color: AppTokens.iconGrey),
          child: _buildLocationText(),
        ),
      ],
    );
  }

  Widget _buildMetaRow({required Widget icon, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 6.w),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildFamilyAvatar() {
    return Container(
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        shape: BoxShape.circle,
        image: jobDetails.familyAvatarUrl != null
            ? DecorationImage(
                image: NetworkImage(jobDetails.familyAvatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: jobDetails.familyAvatarUrl == null
          ? Icon(Icons.person, size: 10.w, color: AppTokens.iconGrey)
          : null,
    );
  }

  Widget _buildFamilyText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
        children: [
          TextSpan(
            text: jobDetails.familyName,
            style: const TextStyle(
              color: AppTokens.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '  (${jobDetails.childrenCount} Children)',
            style: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenText() {
    return Wrap(
      children: jobDetails.children.asMap().entries.map((entry) {
        final isLast = entry.key == jobDetails.children.length - 1;
        final child = entry.value;
        return RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
            children: [
              TextSpan(
                text: child.name,
                style: const TextStyle(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' (${child.age} Years)',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (!isLast)
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color(0xFFD0D5DD),
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.sp, fontFamily: 'Inter'),
        children: [
          TextSpan(
            text: jobDetails.location,
            style: const TextStyle(
              color: AppTokens.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (jobDetails.distance.isNotEmpty)
            TextSpan(
              text: '  (${jobDetails.distance})',
              style: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkillChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: jobDetails.requiredSkills
          .map((skill) => AppTagChip(label: skill))
          .toList(),
    );
  }

  Widget _buildServiceDetailsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic service details
        _buildKeyValueRow('Date', jobDetails.dateRange),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Time', jobDetails.timeRange),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Personality', jobDetails.personality),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Allergies', jobDetails.allergies),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Triggers', jobDetails.triggers),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Calming Methods', jobDetails.calmingMethods),
        SizedBox(height: 10.h),
        _buildKeyValueRow('Additional Notes', jobDetails.additionalNotes),

        // Transportation section
        if (jobDetails.transportationModes.isNotEmpty ||
            jobDetails.equipmentSafety.isNotEmpty ||
            jobDetails.pickupDropoffDetails.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Text(
            'Transportation Preferences (Optional)',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12.h),
          if (jobDetails.transportationModes.isNotEmpty)
            _buildMultiValueRow(
                'Transportation Mode', jobDetails.transportationModes),
          if (jobDetails.equipmentSafety.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildMultiValueRow(
                'Equipment & Safety', jobDetails.equipmentSafety),
          ],
          if (jobDetails.pickupDropoffDetails.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildMultiValueRow(
                'Pickup / Drop-off Details', jobDetails.pickupDropoffDetails),
          ],
        ],
      ],
    );
  }

  Widget _buildKeyValueRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiValueRow(String label, List<String> values) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: values
                .map((value) => Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTokens.textSecondary,
                          fontFamily: 'Inter',
                          height: 1.4,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
