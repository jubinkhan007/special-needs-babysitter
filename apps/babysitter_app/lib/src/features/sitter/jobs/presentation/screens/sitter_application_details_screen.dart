import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../application/data/models/application_model.dart';
import '../../../application/presentation/providers/application_providers.dart';
import '../widgets/job_status_badge.dart';
import '../widgets/job_meta_header.dart';
import '../widgets/key_value_row.dart';
import '../widgets/section_divider.dart';
import '../widgets/soft_skill_chip.dart';
import '../widgets/status_pill.dart';
import '../widgets/bottom_primary_button.dart';
import '../../../saved_jobs/presentation/providers/saved_jobs_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Screen showing details of a job application the sitter has already submitted.
class SitterApplicationDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const SitterApplicationDetailsScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync =
        ref.watch(sitterApplicationDetailsProvider(applicationId));

    return applicationAsync.when(
      data: (application) => _buildContent(context, ref, application),
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceTint,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: const Color(0xFF667085), size: 24.w),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: Text(
            'Applied',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonDark,
              fontFamily: 'Inter',
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceTint,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: const Color(0xFF667085), size: 24.w),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: Text(
            'Applied',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonDark,
              fontFamily: 'Inter',
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Error loading application: $error',
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, ApplicationModel application) {
    final job = application.job;
    final timeAgo = timeago.format(application.createdAt);
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    final jobId = job.id;
    final isSaved = savedJobsState.savedJobIds.contains(jobId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceTint,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Applied',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.buttonDark,
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
      ),
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
                            job.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(savedJobsControllerProvider.notifier)
                                .toggleSaved(jobId)
                                .then((isSaved) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(isSaved ? 'Job saved' : 'Job unsaved'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }).catchError((error) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceFirst('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: const Color(0xFF667085),
                              size: 24.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Family Info & Location (Header)
                  JobMetaHeader(
                    familyName: job.familyName,
                    childCount: '${job.childrenCount} Children',
                    avatarUrl: job.familyPhotoUrl,
                    location: job.location,
                    distance: '7.35 km away', // In real app, calculate this
                  ),
                  SizedBox(height: 16.h),

                  const SectionDivider(),
                  SizedBox(height: 16.h),

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
                            value:
                                _formatDateRange(job.startDate, job.endDate)),
                        KeyValueRow(
                            label: 'Time',
                            value: '${job.startTime} - ${job.endTime}'),
                        KeyValueRow(
                            label: 'No of Days',
                            value:
                                '${_calculateDays(job.startDate, job.endDate)}'),

                        if (job.additionalDetails != null &&
                            job.additionalDetails!.isNotEmpty) ...[
                          KeyValueRow(
                              label: 'Additional Notes',
                              value: job.additionalDetails!),
                        ],

                        // Transportation Preferences
                        if (_hasTransportationData(job.children)) ...[
                          SizedBox(height: 24.h),
                          Text(
                            'Transportation Preferences (Optional)',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          if (_getTransportationModes(job.children).isNotEmpty)
                            _buildListValueRow('Transportation Mode',
                                _getTransportationModes(job.children)),
                          if (_getEquipmentSafety(job.children).isNotEmpty)
                            _buildListValueRow('Equipment & Safety',
                                _getEquipmentSafety(job.children)),
                          if (_getPickupDropoffDetails(job.children) != null)
                            KeyValueRow(
                              label: 'Pickup / Drop-off\nDetails',
                              value: _getPickupDropoffDetails(job.children)!,
                            ),
                        ],

                        SizedBox(height: 24.h),
                        const SectionDivider(),
                        SizedBox(height: 16.h),

                        // Skill Chips
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: const [
                            SoftSkillChip(label: 'CPR'),
                            SoftSkillChip(label: 'First-aid'),
                            SoftSkillChip(label: 'Special Needs Training'),
                          ],
                        ),

                        if (application.coverLetter != null &&
                            application.coverLetter!.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          const SectionDivider(),
                          SizedBox(height: 16.h),
                          Text(
                            'Cover Letter',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            application.coverLetter!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: const Color(0xFF667085),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],

                        SizedBox(height: 24.h),
                        const SectionDivider(),
                        SizedBox(height: 16.h),

                        // Price, Date, Status Row
                        Row(
                          children: [
                            Text(
                              '\$${job.payRate.toStringAsFixed(0)}',
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
                              timeAgo,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 12.w),
                            StatusPill(
                              status: _mapApplicationStatusToJobStatus(
                                  application.status),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed Bottom Button
          BottomPrimaryButton(
            text: 'Back to Job List',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildListValueRow(String label, List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF667085),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values
                  .map((v) => Text(
                        v,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101828),
                          fontFamily: 'Inter',
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  JobApplicationStatus _mapApplicationStatusToJobStatus(String status) {
    try {
      return JobApplicationStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
        orElse: () => JobApplicationStatus.pending,
      );
    } catch (_) {
      return JobApplicationStatus.pending;
    }
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

  int _calculateDays(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return end.difference(start).inDays + 1;
    } catch (_) {
      return 1;
    }
  }

  bool _hasTransportationData(List<ApplicationChildModel> children) {
    for (final child in children) {
      if (child.transportationModes.isNotEmpty ||
          child.equipmentSafety.isNotEmpty ||
          child.pickupLocation != null ||
          child.dropoffLocation != null ||
          child.transportSpecialInstructions != null) {
        return true;
      }
    }
    return false;
  }

  List<String> _getTransportationModes(List<ApplicationChildModel> children) {
    final modes = <String>{};
    for (final child in children) {
      modes.addAll(child.transportationModes);
    }
    return modes.toList();
  }

  List<String> _getEquipmentSafety(List<ApplicationChildModel> children) {
    final equipment = <String>{};
    for (final child in children) {
      equipment.addAll(child.equipmentSafety);
    }
    return equipment.toList();
  }

  String? _getPickupDropoffDetails(List<ApplicationChildModel> children) {
    final details = <String>[];
    for (final child in children) {
      if (child.pickupLocation != null) {
        details.add(child.pickupLocation!);
      }
      if (child.dropoffLocation != null) {
        details.add('Home — ${child.dropoffLocation!}');
      }
      if (child.transportSpecialInstructions != null) {
        details.add(child.transportSpecialInstructions!);
      }
    }
    return details.isEmpty ? null : details.join('\n\n');
  }
}
