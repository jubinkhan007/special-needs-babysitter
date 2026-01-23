import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../jobs/data/models/job_request_details_model.dart';
import '../../../jobs/presentation/providers/job_request_providers.dart';
import '../../../jobs/presentation/widgets/job_meta_header.dart';
import '../../../jobs/presentation/widgets/key_value_row.dart';
import '../../../jobs/presentation/widgets/soft_skill_chip.dart';
import '../../../jobs/presentation/widgets/section_divider.dart';

/// Screen showing details of an upcoming/confirmed booking.
class SitterBookingDetailsScreen extends ConsumerStatefulWidget {
  final String applicationId;
  final String? initialStatus;

  const SitterBookingDetailsScreen({
    super.key,
    required this.applicationId,
    this.initialStatus,
  });

  @override
  ConsumerState<SitterBookingDetailsScreen> createState() =>
      _SitterBookingDetailsScreenState();
}

class _SitterBookingDetailsScreenState
    extends ConsumerState<SitterBookingDetailsScreen> {
  bool _isClockingIn = false;

  @override
  Widget build(BuildContext context) {
    final jobDetailsAsync =
        ref.watch(jobRequestDetailsProvider(widget.applicationId));

    return jobDetailsAsync.when(
      data: (jobDetails) => _buildContent(context, ref, jobDetails),
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context,
            title: _getAppBarTitle(widget.initialStatus)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context,
            title: _getAppBarTitle(widget.initialStatus)),
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

  PreferredSizeWidget _buildAppBar(BuildContext context, {String? title}) {
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
        title ?? 'Booking Details',
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
    final statusValue = widget.initialStatus?.trim() ?? '';
    final statusLower = statusValue.toLowerCase();
    final isCompleted = statusLower == 'completed';
    final statusLabel = _formatStatusLabel(statusValue);
    final scheduledDate = _formatScheduledDate(jobDetails.startDate);
    final totalHours =
        jobDetails.totalHours ?? _calculateTotalHours(jobDetails);
    final subTotal =
        jobDetails.subTotal ?? (jobDetails.payRate * (totalHours ?? 0));
    final platformFee = jobDetails.platformFee ?? 0;
    final discount = jobDetails.discount ?? 0;
    final estimatedTotal = subTotal + platformFee - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _buildAppBar(context, title: _getAppBarTitle(widget.initialStatus)),
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

                  if (jobDetails.children.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Children',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...jobDetails.children.map((child) => Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF2F4F7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.person_outline,
                                          size: 20.w,
                                          color: const Color(0xFF667085)),
                                    ),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.firstName,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF344054),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Text(
                                          '${child.age} years old',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0xFF667085),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],

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
                            if (isCompleted) ...[
                              Text(
                                scheduledDate.isNotEmpty
                                    ? 'Scheduled: $scheduledDate'
                                    : 'Scheduled',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF667085),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _buildStatusPill(statusLabel),
                            ] else if (jobDetails.isToday)
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
                        if (isCompleted) ...[
                          SizedBox(height: 24.h),
                          const SectionDivider(),
                          SizedBox(height: 16.h),
                          KeyValueRow(
                            label: 'Sub Total',
                            value: _formatCurrency(subTotal),
                            isBoldValue: false,
                          ),
                          KeyValueRow(
                            label: 'Total Hours',
                            value: '${_formatHours(totalHours)} Hours',
                            isBoldValue: false,
                          ),
                          KeyValueRow(
                            label: 'Hourly Rate',
                            value:
                                '\$${jobDetails.payRate.toStringAsFixed(0)}/hr',
                            isBoldValue: false,
                          ),
                          KeyValueRow(
                            label: 'Platform Fee',
                            value: _formatCurrency(platformFee),
                            isBoldValue: false,
                          ),
                          KeyValueRow(
                            label: 'Discount',
                            value: _formatCurrency(discount),
                            isBoldValue: false,
                          ),
                          KeyValueRow(
                            label: 'Estimated Total Cost',
                            value: _formatCurrency(estimatedTotal),
                          ),
                        ],
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isCompleted)
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
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        _showMarkCompleteDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87C4F2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Mark Job as Complete',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report issue coming soon'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1D2939),
                        side: const BorderSide(color: Color(0xFFD0D5DD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Report An Issue',
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
            )
          else
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (jobDetails.clockInMessage != null &&
                      jobDetails.clockInMessage!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3F2),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFFFECDCA)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16.sp, color: const Color(0xFFB42318)),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              jobDetails.clockInMessage!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFFB42318),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: (jobDetails.canClockIn && !_isClockingIn)
                                ? () async {
                                    final actionApplicationId =
                                        jobDetails.applicationId.isNotEmpty
                                            ? jobDetails.applicationId
                                            : widget.applicationId;
                                    await _clockIn(
                                      context,
                                      ref,
                                      actionApplicationId,
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF87C4F2),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: _isClockingIn
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
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

  String _getAppBarTitle(String? status) {
    final label = _formatStatusLabel(status?.trim() ?? '');
    if (label.toLowerCase() == 'completed') {
      return 'Completed';
    }
    return 'Booking Details';
  }

  String _formatStatusLabel(String status) {
    if (status.isEmpty) {
      return '';
    }
    final parts = status.split('_');
    final words = parts.map((part) {
      if (part.isEmpty) {
        return part;
      }
      final lower = part.toLowerCase();
      return '${lower[0].toUpperCase()}${lower.substring(1)}';
    }).toList();
    return words.join(' ');
  }

  String _formatScheduledDate(String startDate) {
    try {
      final start = DateTime.parse(startDate);
      return '${start.day} ${_getMonthName(start.month)}, ${start.year}';
    } catch (_) {
      return '';
    }
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(0)}';
  }

  String _formatHours(double? hours) {
    if (hours == null) {
      return '0';
    }
    if (hours == hours.roundToDouble()) {
      return hours.toStringAsFixed(0);
    }
    return hours.toStringAsFixed(1);
  }

  double? _calculateTotalHours(JobRequestDetailsModel jobDetails) {
    final minutes = _minutesBetweenTimes(
      jobDetails.startTime,
      jobDetails.endTime,
    );
    if (minutes == null) {
      return null;
    }
    final totalMinutes = minutes * jobDetails.numberOfDays;
    return totalMinutes / 60;
  }

  int? _minutesBetweenTimes(String startTime, String endTime) {
    final startMinutes = _parseTimeToMinutes(startTime);
    final endMinutes = _parseTimeToMinutes(endTime);
    if (startMinutes == null || endMinutes == null) {
      return null;
    }
    if (endMinutes >= startMinutes) {
      return endMinutes - startMinutes;
    }
    return (24 * 60 - startMinutes) + endMinutes;
  }

  int? _parseTimeToMinutes(String time) {
    try {
      final trimmed = time.trim();
      if (trimmed.isEmpty) {
        return null;
      }

      final lower = trimmed.toLowerCase();
      final isAm = lower.contains('am');
      final isPm = lower.contains('pm');
      final sanitized = lower.replaceAll(RegExp(r'[^0-9:]'), '');

      if (sanitized.isEmpty) {
        return null;
      }

      final parts = sanitized.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (minute < 0 || minute > 59) {
        return null;
      }

      var adjustedHour = hour;
      if (isPm && adjustedHour < 12) {
        adjustedHour += 12;
      }
      if (isAm && adjustedHour == 12) {
        adjustedHour = 0;
      }

      return adjustedHour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  Widget _buildStatusPill(String status) {
    final label = status.isNotEmpty ? status : 'Completed';
    final color = _getStatusColor(label);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'accepted':
      case 'active':
        return const Color(0xFF12B76A);
      case 'declined':
      case 'cancelled':
        return const Color(0xFFF04438);
      case 'invited':
        return const Color(0xFF175CD3);
      default:
        return const Color(0xFFF79009);
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

  Future<void> _showMarkCompleteDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close,
                        color: const Color(0xFF667085), size: 20.w),
                    onPressed: () => context.pop(),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Are You Sure That You Have Completed This Job?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D2939),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.info_outline,
                        color: const Color(0xFF98A2B3), size: 18.w),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87C4F2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D2939),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'No',
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
        );
      },
    );
  }

  Future<void> _clockIn(
    BuildContext context,
    WidgetRef ref,
    String applicationId,
  ) async {
    if (_isClockingIn) {
      return;
    }
    setState(() => _isClockingIn = true);
    try {
      await ref
          .read(jobRequestRepositoryProvider)
          .clockInBooking(applicationId);
      if (!mounted) {
        return;
      }
      await _showClockInDialog(context);
      ref.invalidate(jobRequestDetailsProvider(applicationId));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isClockingIn = false);
      }
    }
  }

  Future<void> _showClockInDialog(BuildContext context) async {
    final time = _formatClockInTime(TimeOfDay.now());
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close,
                        color: const Color(0xFF667085), size: 20.w),
                    onPressed: () => context.pop(),
                  ),
                ),
                Text(
                  'Clocked In\nSuccessfully!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Start Time:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'You Clocked in at $time',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Geo-Tracking Notification:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your location is now visible to the family.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87C4F2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Confirm',
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
        );
      },
    );
  }

  String _formatClockInTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
