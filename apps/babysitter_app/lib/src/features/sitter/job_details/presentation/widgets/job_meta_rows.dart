import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

import '../../../../../theme/app_tokens.dart';
import '../../domain/entities/sitter_job_details.dart';

/// Family, children, and location meta rows.
class JobMetaRows extends StatelessWidget {
  final String familyName;
  final String? familyAvatarUrl;
  final int childrenCount;
  final List<JobChildInfo> children;
  final String location;
  final String distance;

  const JobMetaRows({
    super.key,
    required this.familyName,
    this.familyAvatarUrl,
    required this.childrenCount,
    required this.children,
    required this.location,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Family row
          _buildMetaRow(
            icon: _buildFamilyAvatar(),
            content: _buildFamilyText(),
          ),
          SizedBox(height: 8.h),
          // Children row
          _buildMetaRow(
            icon: Icon(
              Icons.child_care_rounded,
              size: 16.w,
              color: AppTokens.iconGrey,
            ),
            content: _buildChildrenText(),
          ),
          SizedBox(height: 8.h),
          // Location row
          _buildMetaRow(
            icon: Icon(
              Icons.location_on_outlined,
              size: 16.w,
              color: AppTokens.iconGrey,
            ),
            content: _buildLocationText(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow({required Widget icon, required Widget content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 8.w),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildFamilyAvatar() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        shape: BoxShape.circle,
        image: familyAvatarUrl != null
            ? DecorationImage(
                image: NetworkImage(familyAvatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: familyAvatarUrl == null
          ? Icon(
              Icons.person,
              size: 12.w,
              color: AppTokens.iconGrey,
            )
          : null,
    );
  }

  Widget _buildFamilyText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(
            text: familyName,
            style: const TextStyle(
              color: AppTokens.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' ($childrenCount Children)',
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
      children: children.asMap().entries.map((entry) {
        final isLast = entry.key == children.length - 1;
        final child = entry.value;
        return RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Inter',
            ),
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
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(
            text: location,
            style: const TextStyle(
              color: AppTokens.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' ($distance)',
            style: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
