import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Service details table with key-value rows.
class ServiceDetailsTable extends StatelessWidget {
  final String dateRange;
  final String timeRange;
  final String personality;
  final String allergies;
  final String triggers;
  final String calmingMethods;
  final String additionalNotes;

  const ServiceDetailsTable({
    super.key,
    required this.dateRange,
    required this.timeRange,
    required this.personality,
    required this.allergies,
    required this.triggers,
    required this.calmingMethods,
    required this.additionalNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Service Details',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 16.h),
          // Key-value rows
          _buildRow('Date', dateRange),
          SizedBox(height: 12.h),
          _buildRow('Time', timeRange),
          SizedBox(height: 12.h),
          _buildRow('Personality', personality),
          SizedBox(height: 12.h),
          _buildRow('Allergies', allergies),
          SizedBox(height: 12.h),
          _buildRow('Triggers', triggers),
          SizedBox(height: 12.h),
          _buildRow('Calming Methods', calmingMethods),
          SizedBox(height: 12.h),
          _buildRow('Additional Notes', additionalNotes),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (fixed width for alignment)
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textSecondary,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
        // Value (flexible, right-aligned)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
