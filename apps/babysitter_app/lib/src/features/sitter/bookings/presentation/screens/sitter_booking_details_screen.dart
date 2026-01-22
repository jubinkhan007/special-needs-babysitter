import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../jobs/data/models/job_request_details_model.dart';
import '../../../jobs/presentation/providers/job_request_providers.dart';
import '../../../jobs/presentation/widgets/job_meta_header.dart';
import '../../../jobs/presentation/widgets/key_value_row.dart';
import '../../../jobs/presentation/widgets/soft_skill_chip.dart';

/// Screen showing details of an upcoming/confirmed booking.
class SitterBookingDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const SitterBookingDetailsScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailsAsync = ref.watch(jobRequestDetailsProvider(applicationId));

    return jobDetailsAsync.when(
      data: (jobDetails) => _buildContent(context, ref, jobDetails),
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
                  'Error loading booking details',
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
        'Booking Details',
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
      BuildContext context, WidgetRef ref, JobRequestDetailsModel jobDetails) {
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

                        // Transportation Preferences Section
                        if (_hasTransportationData(jobDetails)) ...[
                          SizedBox(height: 24.h),
                          Text(
                            'Transportation Preferences (Optional)',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          if (jobDetails.transportationModes.isNotEmpty)
                            _buildListValueRow('Transportation Mode',
                                jobDetails.transportationModes),
                          if (jobDetails.equipmentSafety.isNotEmpty)
                            _buildListValueRow('Equipment & Safety',
                                jobDetails.equipmentSafety),
                          if (_hasPickupDropoffDetails(jobDetails))
                            _buildDetailedValueRow('Pickup / Drop-off\nDetails',
                                _getPickupDropoffDetails(jobDetails)),
                        ],

                        // Skills
                        if (jobDetails.sitterSkills.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: jobDetails.sitterSkills
                                .map((skill) => SoftSkillChip(label: skill))
                                .toList(),
                          ),
                        ],

                        SizedBox(height: 24.h),

                        // Price and Today Badge
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
                            if (jobDetails.isToday)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FADF),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6.w,
                                      height: 6.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF12B76A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF027A48),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
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

          // Fixed Bottom Clock In Button
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
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: jobDetails.canClockIn
                          ? () {
                              // TODO: Implement clock in logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Clock in functionality coming soon'),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87C4F2),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF87C4F2).withValues(alpha: 0.6),
                        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Clock In',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD0D5DD)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_vert,
                        color: const Color(0xFF667085), size: 20.w),
                    onPressed: () {
                      // TODO: Show more options menu
                      _showMoreOptionsMenu(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListValueRow(String label, List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF344054),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8.h),
          ...values.map((value) => Padding(
                padding: EdgeInsets.only(bottom: 4.h, left: 16.w),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDetailedValueRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF344054),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF667085),
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasTransportationData(JobRequestDetailsModel jobDetails) {
    return jobDetails.transportationModes.isNotEmpty ||
        jobDetails.equipmentSafety.isNotEmpty ||
        _hasPickupDropoffDetails(jobDetails);
  }

  bool _hasPickupDropoffDetails(JobRequestDetailsModel jobDetails) {
    return (jobDetails.pickupLocation != null &&
            jobDetails.pickupLocation!.isNotEmpty) ||
        (jobDetails.dropoffLocation != null &&
            jobDetails.dropoffLocation!.isNotEmpty) ||
        (jobDetails.transportSpecialInstructions != null &&
            jobDetails.transportSpecialInstructions!.isNotEmpty);
  }

  String _getPickupDropoffDetails(JobRequestDetailsModel jobDetails) {
    final details = <String>[];

    if (jobDetails.pickupLocation != null &&
        jobDetails.pickupLocation!.isNotEmpty) {
      details.add(jobDetails.pickupLocation!);
    }

    if (jobDetails.dropoffLocation != null &&
        jobDetails.dropoffLocation!.isNotEmpty) {
      details.add('Home — ${jobDetails.dropoffLocation!}');
    }

    if (jobDetails.transportSpecialInstructions != null &&
        jobDetails.transportSpecialInstructions!.isNotEmpty) {
      details.add(jobDetails.transportSpecialInstructions!);
    }

    return details.join('\n\n');
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

  void _showMoreOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.message_outlined, color: Color(0xFF344054)),
              title: Text(
                'Message Family',
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                context.pop();
                // TODO: Navigate to messages
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.cancel_outlined, color: Color(0xFF344054)),
              title: Text(
                'Cancel Booking',
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                context.pop();
                // TODO: Show cancel confirmation
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF344054)),
              title: Text(
                'Get Help',
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                context.pop();
                // TODO: Open support
              },
            ),
          ],
        ),
      ),
    );
  }
}
