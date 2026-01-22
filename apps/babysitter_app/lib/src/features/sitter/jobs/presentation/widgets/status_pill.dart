import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'job_status_badge.dart'; // To reuse the enum

class StatusPill extends StatelessWidget {
  final JobApplicationStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case JobApplicationStatus.pending:
        return const Color(0xFFFEF0C7);
      case JobApplicationStatus.reviewing:
        return const Color(0xFFD1E9FF);
      case JobApplicationStatus.declined:
        return const Color(0xFFFEE4E2);
      case JobApplicationStatus.withdrawn:
        return const Color(0xFFF2F4F7);
      default:
        return const Color(0xFFF2F4F7);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case JobApplicationStatus.pending:
        return const Color(0xFFDC6803);
      case JobApplicationStatus.reviewing:
        return const Color(0xFF175CD3);
      case JobApplicationStatus.declined:
        return const Color(0xFFD92D20);
      case JobApplicationStatus.withdrawn:
        return const Color(0xFF344054);
      default:
        return const Color(0xFF344054);
    }
  }

  String _getText() {
    switch (status) {
      case JobApplicationStatus.pending:
        return 'Pending';
      case JobApplicationStatus.reviewing:
        return 'Reviewing';
      case JobApplicationStatus.declined:
        return 'Declined';
      case JobApplicationStatus.withdrawn:
        return 'Withdrawn';
      default:
        return status.name
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }
}
