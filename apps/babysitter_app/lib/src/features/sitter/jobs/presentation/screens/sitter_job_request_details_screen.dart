import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/job_request_details_model.dart';
import '../providers/job_request_providers.dart';
import '../providers/sitter_job_applications_provider.dart';
import '../widgets/job_meta_header.dart';
import '../widgets/key_value_row.dart';
import '../widgets/soft_skill_chip.dart';

/// Screen showing details of a job request (invitation) that a sitter received.
class SitterJobRequestDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const SitterJobRequestDetailsScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailsAsync = ref.watch(jobRequestDetailsProvider(applicationId));
    final controllerState = ref.watch(jobRequestControllerProvider);

    // Listen to controller state changes
    ref.listen<AsyncValue<void>>(
      jobRequestControllerProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            // Success - show message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Action completed successfully'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            // Invalidate the job applications lists to refresh
            ref.invalidate(sitterJobApplicationsProvider);
            ref.invalidate(sitterJobRequestsProvider);
            context.pop();
          },
          error: (error, stack) {
            // Error - show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString().replaceFirst('Exception: ', '')),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          },
        );
      },
    );

    return jobDetailsAsync.when(
      data: (jobDetails) => _buildContent(context, ref, jobDetails, controllerState),
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64.w, color: const Color(0xFFEF4444)),
                SizedBox(height: 16.h),
                Text(
                  'Error loading job request',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon:
            Icon(Icons.arrow_back, color: const Color(0xFF667085), size: 24.w),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: Text(
        'Job Request',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1D2939),
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.headset_mic_outlined,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () {
            // TODO: Open support chat
          },
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, JobRequestDetailsModel jobDetails, AsyncValue<void> controllerState) {
    final isLoading = controllerState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Job Title and Bookmark
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            jobDetails.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Icon(Icons.bookmark_border,
                            color: const Color(0xFF667085), size: 24.w),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Family Info & Location
                  JobMetaHeader(
                    familyName: '${jobDetails.familyName} Family',
                    childCount:
                        '${jobDetails.childrenCount} ${jobDetails.childrenCount == 1 ? 'Child' : 'Children'}',
                    avatarUrl: null,
                    location: jobDetails.location,
                    distance: jobDetails.distance != null
                        ? '${jobDetails.distance!.toStringAsFixed(2)} km away'
                        : null,
                  ),

                  SizedBox(height: 24.h),

                  // Service Details Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Details',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101828),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 16.h),

                        KeyValueRow(
                          label: 'Date',
                          value: _formatDateRange(
                              jobDetails.startDate, jobDetails.endDate),
                        ),
                        KeyValueRow(
                          label: 'Time',
                          value:
                              '${_formatTime(jobDetails.startTime)} - ${_formatTime(jobDetails.endTime)}',
                        ),
                        KeyValueRow(
                          label: 'No of Days',
                          value: '${jobDetails.numberOfDays}',
                        ),

                        if (jobDetails.additionalNotes != null &&
                            jobDetails.additionalNotes!.isNotEmpty)
                          KeyValueRow(
                            label: 'Additional Notes',
                            value: jobDetails.additionalNotes!,
                          ),

                        // Skills
                        if (jobDetails.sitterSkills.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: jobDetails.sitterSkills
                                .map((skill) => SoftSkillChip(label: skill))
                                .toList(),
                          ),
                        ],

                        SizedBox(height: 24.h),

                        // Price, Time Ago, Status Row
                        Row(
                          children: [
                            Text(
                              '\$${jobDetails.payRate.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF101828),
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              '/hr',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '2 day ago', // Placeholder - would need timestamp
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF8FF),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                'Invited',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF175CD3),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: Offset(0, -2.h),
                  blurRadius: 8.r,
                ),
              ],
            ),
            child: Column(
              children: [
                // Accept Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await ref
                                .read(jobRequestControllerProvider.notifier)
                                .acceptJobInvitation(applicationId);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87C4F2),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF87C4F2).withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Decline Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await ref
                                .read(jobRequestControllerProvider.notifier)
                                .declineJobInvitation(applicationId);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D2939),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1D2939).withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Decline',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      if (start.year == end.year &&
          start.month == end.month &&
          start.day == end.day) {
        return '${start.day} ${_getMonthName(start.month)}';
      }
      return '${start.day} ${_getMonthName(start.month)} - ${end.day} ${_getMonthName(end.month)}';
    } catch (_) {
      return '$startDate - $endDate';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(String time) {
    try {
      // Assuming time is in "HH:mm" format
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      }
      return time;
    } catch (_) {
      return time;
    }
  }
}
