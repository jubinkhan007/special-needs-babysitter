import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum JobApplicationStatus {
  pending,
  reviewing,
  accepted,
  declined,
  withdrawn,
  invited,
  in_progress,
  clocked_out,
  completed,
  cancelled,
  expired,
}

class JobStatusBadge extends StatelessWidget {
  final JobApplicationStatus status;

  const JobStatusBadge({
    super.key,
    required this.status,
  });

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
      case JobApplicationStatus.accepted:
        return const Color(0xFFD1FADF);
      case JobApplicationStatus.declined:
        return const Color(0xFFFEE4E2);
      case JobApplicationStatus.withdrawn:
        return const Color(0xFFF2F4F7);
      case JobApplicationStatus.invited:
        return const Color(0xFFE9D7FE);
      case JobApplicationStatus.in_progress:
        return const Color(0xFFD1E9FF);
      case JobApplicationStatus.clocked_out:
        return const Color(0xFFFEF3F2);
      case JobApplicationStatus.completed:
        return const Color(0xFFD1FADF);
      case JobApplicationStatus.cancelled:
        return const Color(0xFFFEE4E2);
      case JobApplicationStatus.expired:
        return const Color(0xFFF2F4F7);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case JobApplicationStatus.pending:
        return const Color(0xFFDC6803);
      case JobApplicationStatus.reviewing:
        return const Color(0xFF175CD3);
      case JobApplicationStatus.accepted:
        return const Color(0xFF027A48);
      case JobApplicationStatus.declined:
        return AppColors.error;
      case JobApplicationStatus.withdrawn:
        return const Color(0xFF344054);
      case JobApplicationStatus.invited:
        return const Color(0xFF6941C6);
      case JobApplicationStatus.in_progress:
        return const Color(0xFF175CD3);
      case JobApplicationStatus.clocked_out:
        return const Color(0xFFB42318);
      case JobApplicationStatus.completed:
        return const Color(0xFF027A48);
      case JobApplicationStatus.cancelled:
        return AppColors.error;
      case JobApplicationStatus.expired:
        return const Color(0xFF344054);
    }
  }

  String _getText() {
    switch (status) {
      case JobApplicationStatus.pending:
        return 'Pending';
      case JobApplicationStatus.reviewing:
        return 'Reviewing';
      case JobApplicationStatus.accepted:
        return 'Accepted';
      case JobApplicationStatus.declined:
        return 'Declined';
      case JobApplicationStatus.withdrawn:
        return 'Withdrawn';
      case JobApplicationStatus.invited:
        return 'Invited';
      case JobApplicationStatus.in_progress:
        return 'In Progress';
      case JobApplicationStatus.clocked_out:
        return 'Clocked Out';
      case JobApplicationStatus.completed:
        return 'Completed';
      case JobApplicationStatus.cancelled:
        return 'Cancelled';
      case JobApplicationStatus.expired:
        return 'Expired';
    }
  }
}
