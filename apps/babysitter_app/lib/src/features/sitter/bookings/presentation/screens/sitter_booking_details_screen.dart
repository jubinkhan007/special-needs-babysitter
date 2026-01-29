import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../../../jobs/data/models/job_request_details_model.dart';
import '../../../jobs/presentation/providers/job_request_providers.dart';
import '../../../jobs/presentation/widgets/job_meta_header.dart';
import '../../../jobs/presentation/widgets/key_value_row.dart';
import '../../../jobs/presentation/widgets/soft_skill_chip.dart';
import '../../../jobs/presentation/widgets/section_divider.dart';
import '../../../../messages/domain/chat_thread_args.dart';
import '../../../../bookings/domain/booking_status.dart';
import '../../../../bookings/domain/review/review_args.dart';
import '../../../../bookings/presentation/models/booking_details_ui_model.dart';
import '../providers/bookings_providers.dart';
import '../providers/session_tracking_providers.dart';
import '../../../saved_jobs/presentation/providers/saved_jobs_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/routing/routes.dart';

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
  bool _hasRedirectedToActive = false;
  static const String _emergencySelection = 'Emergency Situation';
  static const String _emergencyPayloadReason =
      'Medical emergency - unable to fulfill booking';
  static const String _standardPayloadReason =
      'Family emergency - unable to fulfill booking';

  @override
  Widget build(BuildContext context) {
    final jobDetailsAsync =
        ref.watch(jobRequestDetailsProvider(widget.applicationId));
    final trackingState = ref.watch(sessionTrackingControllerProvider);
    final session = trackingState.session;

    final hasActiveSession =
        session != null && session.applicationId == widget.applicationId;
    if (hasActiveSession) {
      if (!_hasRedirectedToActive) {
        _hasRedirectedToActive = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.go('${Routes.sitterActiveBooking}/${widget.applicationId}');
        });
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context, title: 'Booking Details'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return jobDetailsAsync.when(
      data: (jobDetails) {
        // DEBUG: Log location and clock-in info
        print('=== CLOCK IN DEBUG ===');
        print('canClockIn: ${jobDetails.canClockIn}');
        print('clockInMessage: ${jobDetails.clockInMessage}');
        print('isToday: ${jobDetails.isToday}');
        print('Job location: ${jobDetails.location}');
        print('Job fullAddress: ${jobDetails.fullAddress}');
        print(
            'Job coordinates: ${jobDetails.jobCoordinates?.latitude}, ${jobDetails.jobCoordinates?.longitude}');
        print('Geofence radius: ${jobDetails.geofenceRadiusMeters} meters');
        print('Start time: ${jobDetails.startTime}');
        print('End time: ${jobDetails.endTime}');
        final localStartDateTime = _parseStartDateTime(jobDetails);
        print('Local startDateTime: $localStartDateTime');
        final now = DateTime.now();
        print('Now (local): $now');
        print('Now (UTC): ${now.toUtc()}');
        print('Timezone offset: ${now.timeZoneOffset}');
        print(
            'Local clock-in window allows: ${_isWithinClockInWindow(jobDetails)}');

        // DEBUG: Get and log device location (non-blocking)
        _logDeviceLocation();

        return _buildContent(context, ref, jobDetails);
      },
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        appBar:
            _buildAppBar(context, title: _getAppBarTitle(widget.initialStatus)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.white,
        appBar:
            _buildAppBar(context, title: _getAppBarTitle(widget.initialStatus)),
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
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(Routes.sitterBookings);
          }
        },
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
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    final jobId = jobDetails.id;
    final isSaved = savedJobsState.savedJobIds.contains(jobId);
    final fallbackStatus = jobDetails.status.trim();
    final statusValue =
        (widget.initialStatus?.trim().isNotEmpty == true)
            ? widget.initialStatus!.trim()
            : fallbackStatus;
    final statusLower = statusValue.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    final isCompleted = statusLower == 'completed' ||
        (statusLower == 'clockedout' && _hasFinalEndPassed(jobDetails));
    final statusLabel = _formatStatusLabel(statusValue);
    final scheduledDate = _formatScheduledDate(jobDetails.startDate);
    final totalHours =
        jobDetails.totalHours ?? _calculateTotalHours(jobDetails);
    final subTotal =
        jobDetails.subTotal ?? (jobDetails.payRate * (totalHours ?? 0));
    final platformFee = jobDetails.platformFee ?? 0;
    final discount = jobDetails.discount ?? 0;
    final estimatedTotal = subTotal + platformFee - discount;
    final clockInState = _resolveClockInState(jobDetails);

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
                                  backgroundColor: const Color(0xFF22C55E),
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
                          child: Icon(
                            isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: const Color(0xFF667085),
                            size: 24.w,
                          ),
                        ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                        _showMarkCompleteDialog(
                          context,
                          jobDetails.applicationId,
                          jobDetails,
                        );
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
                        AppToast.show(context, 
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
                  if (clockInState.message != null &&
                      clockInState.message!.isNotEmpty) ...[
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
                              clockInState.message!,
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
                            onPressed:
                                (clockInState.canClockIn && !_isClockingIn)
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
                            _showMoreOptionsMenu(context, jobDetails);
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
    final normalized = label.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (normalized == 'completed' || normalized == 'clockedout') {
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

  _ClockInState _resolveClockInState(JobRequestDetailsModel jobDetails) {
    final statusLower =
        (widget.initialStatus ?? '').toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    final isClockedOut = statusLower == 'clockedout';
    final isMultiDay = _isMultiDay(jobDetails);
    final isLastDay = _isLastDay(jobDetails);
    final isFinalEndPassed = _hasFinalEndPassed(jobDetails);
    final serverMessage = jobDetails.clockInMessage?.trim();
    final localWindowAllows = _isWithinClockInWindow(jobDetails);
    if (isClockedOut && (isLastDay || isFinalEndPassed)) {
      return const _ClockInState(
        canClockIn: false,
        message: 'This booking is complete. Please mark the job as complete.',
      );
    }
    if (jobDetails.canClockIn ||
        (isClockedOut && isMultiDay && !isLastDay && localWindowAllows)) {
      return const _ClockInState(canClockIn: true);
    }

    final fallbackMessage = _buildClockInMessage(jobDetails);
    if (localWindowAllows) {
      final mismatchMessage =
          (serverMessage != null && serverMessage.isNotEmpty)
              ? '$serverMessage (Server clock-in window mismatch detected. Please contact support.)'
              : 'Clock-in is blocked by the server despite being within the window. Please contact support.';
      return _ClockInState(
        canClockIn: false,
        message: mismatchMessage,
      );
    }
    return _ClockInState(
      canClockIn: false,
      message: (serverMessage != null && serverMessage.isNotEmpty)
          ? serverMessage
          : fallbackMessage,
    );
  }

  bool _isWithinClockInWindow(JobRequestDetailsModel jobDetails) {
    const windowMinutes = 15;
    final startDateTime = _parseStartDateTime(jobDetails);
    if (startDateTime == null) {
      return false;
    }
    final now = DateTime.now();
    final windowStart =
        startDateTime.subtract(const Duration(minutes: windowMinutes));
    final windowEnd = startDateTime;
    final afterStart =
        now.isAfter(windowStart) || now.isAtSameMomentAs(windowStart);
    final beforeEnd =
        now.isBefore(windowEnd) || now.isAtSameMomentAs(windowEnd);
    return afterStart && beforeEnd;
  }

  String _buildClockInMessage(JobRequestDetailsModel jobDetails) {
    final startDateTime = _parseStartDateTime(jobDetails);
    if (startDateTime == null) {
      return 'Clock in is not available yet.';
    }
    final hour = startDateTime.hour == 0 ? 12 : startDateTime.hour % 12;
    final minute = startDateTime.minute.toString().padLeft(2, '0');
    final period = startDateTime.hour >= 12 ? 'PM' : 'AM';
    return 'You can clock in starting 15 minutes before the scheduled time ($hour:$minute $period).';
  }

  DateTime? _parseStartDateTime(JobRequestDetailsModel jobDetails) {
    final date = _resolveActiveDate(jobDetails);
    final minutes = _parseTimeToMinutes(jobDetails.startTime);
    if (date == null || minutes == null) {
      return null;
    }
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    try {
      final parsed = DateTime.parse(trimmed);
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      final parts = trimmed.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final first = int.tryParse(parts[0]);
        final second = int.tryParse(parts[1]);
        final third = int.tryParse(parts[2]);
        if (first == null || second == null || third == null) {
          return null;
        }
        if (parts[0].length == 4) {
          return DateTime(first, second, third);
        }
        final year = third < 100 ? 2000 + third : third;
        return DateTime(year, first, second);
      }
    }
    return null;
  }

  DateTime? _resolveActiveDate(JobRequestDetailsModel jobDetails) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final start = _parseDate(jobDetails.startDate);
    final end = _parseDate(jobDetails.endDate);
    if (start != null && end != null) {
      final startsBeforeOrToday =
          _isSameDate(todayDate, start) || todayDate.isAfter(start);
      final endsAfterOrToday =
          _isSameDate(todayDate, end) || todayDate.isBefore(end);
      if (startsBeforeOrToday && endsAfterOrToday) {
        return todayDate;
      }
    }
    return start;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isMultiDay(JobRequestDetailsModel jobDetails) {
    if (jobDetails.numberOfDays > 1) {
      return true;
    }
    final start = _parseDate(jobDetails.startDate);
    final end = _parseDate(jobDetails.endDate);
    if (start == null || end == null) {
      return false;
    }
    return !_isSameDate(start, end);
  }

  bool _isLastDay(JobRequestDetailsModel jobDetails) {
    final end = _parseDate(jobDetails.endDate);
    if (end == null) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _isSameDate(today, end);
  }

  bool _hasFinalEndPassed(JobRequestDetailsModel jobDetails) {
    final endDate = _parseDate(jobDetails.endDate);
    final endMinutes = _parseTimeToMinutes(jobDetails.endTime);
    if (endDate == null || endMinutes == null) {
      return false;
    }
    final endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endMinutes ~/ 60,
      endMinutes % 60,
    );
    final now = DateTime.now();
    return now.isAfter(endDateTime) || now.isAtSameMomentAs(endDateTime);
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

  void _showMoreOptionsMenu(
      BuildContext context, JobRequestDetailsModel jobDetails) {
    final parentContext = context;
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) => SafeArea(
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
                Navigator.of(sheetContext).pop();
                final parentUserId = jobDetails.parentUserId;
                if (parentUserId == null || parentUserId.isEmpty) {
                  AppToast.show(
                    parentContext,
                    const SnackBar(
                      content: Text('Family info unavailable.'),
                    ),
                  );
                  return;
                }
                final args = ChatThreadArgs(
                  otherUserId: parentUserId,
                  otherUserName: '${jobDetails.familyName} Family',
                  isVerified: false,
                );
                parentContext.push(
                  '/sitter/messages/chat/$parentUserId',
                  extra: args,
                );
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
                Navigator.of(sheetContext).pop();
                _showCancelReasonSheet(parentContext, jobDetails.applicationId);
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
                Navigator.of(sheetContext).pop();
                // TODO: Open support
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCancelReasonSheet(
    BuildContext context,
    String applicationId,
  ) async {
    final parentContext = context;
    final reasons = <String>[
      _emergencySelection,
      'Unexpected Illness',
      'Scheduling Conflict',
      'Other',
    ];
    String? selectedReason;
    String otherReason = '';

    await showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final media = MediaQuery.of(context);
            final bottomInset = media.viewInsets.bottom;
            final maxHeight = media.size.height * 0.75;
            final requiresOther = selectedReason == 'Other';
            final canProceed = selectedReason != null &&
                (!requiresOther || otherReason.trim().isNotEmpty);
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                16.h,
                20.w,
                16.h + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Reason to Cancel',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101828),
                              fontFamily: 'Inter',
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Color(0xFF101828)),
                            onPressed: () => Navigator.of(sheetContext).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ...reasons.map(
                        (reason) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReason = reason;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedReason == reason
                                          ? const Color(0xFF87C4F2)
                                          : const Color(0xFFD0D5DD),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedReason == reason
                                      ? Center(
                                          child: Container(
                                            width: 10.w,
                                            height: 10.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF87C4F2),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    reason,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF475467),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextField(
                        minLines: 4,
                        maxLines: 4,
                        onChanged: (value) {
                          otherReason = value;
                          setState(() {});
                        },
                        style: TextStyle(
                          color: const Color(0xFF101828),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your reason here...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF98A2B3),
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                                const BorderSide(color: Color(0xFF87C4F2)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        height: 46.h,
                        child: ElevatedButton(
                          onPressed: canProceed
                              ? () {
                                  Navigator.of(sheetContext).pop();
                                  if (selectedReason == _emergencySelection) {
                                    _showEmergencyCancellationDialog(
                                      parentContext,
                                      applicationId,
                                    );
                                  } else {
                                    _showCancellationImpactDialog(
                                      parentContext,
                                      applicationId,
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87C4F2),
                            disabledBackgroundColor: Colors.grey.shade300,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

  }

  Future<void> _showEmergencyCancellationDialog(
    BuildContext context,
    String applicationId,
  ) async {
    final parentContext = context;
    String? fileUrl;
    String? fileName;
    bool isUploading = false;
    bool isSubmitting = false;

    await showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> handleUpload() async {
              if (isUploading) return;
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
              );
              if (result == null || result.files.single.path == null) {
                return;
              }
              final pickedFile = File(result.files.single.path!);
              final pickedName = result.files.single.name;
              setState(() {
                isUploading = true;
                fileName = pickedName;
              });
              try {
                final url = await ref
                    .read(jobRequestRepositoryProvider)
                    .uploadCancellationEvidence(pickedFile);
                if (!dialogContext.mounted) return;
                setState(() {
                  fileUrl = url;
                });
              } catch (e) {
                if (mounted) {
                  AppToast.show(parentContext, 
                    SnackBar(content: Text('Upload failed: $e')),
                  );
                }
                if (!dialogContext.mounted) return;
                setState(() {
                  fileName = null;
                  fileUrl = null;
                });
              } finally {
                if (!dialogContext.mounted) return;
                setState(() {
                  isUploading = false;
                });
              }
            }

            final media = MediaQuery.of(context);
            final maxHeight = media.size.height * 0.8;
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF101828)),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                    Text(
                      'Emergency Cancellation',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101828),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'We understand emergencies happen. If this cancellation is due to an unavoidable situation, let us know below.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF667085),
                        height: 1.3,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Emergency Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101828),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      minLines: 4,
                      maxLines: 4,
                      style: TextStyle(
                        color: const Color(0xFF101828),
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Briefly describe your situation (optional)',
                        hintStyle: TextStyle(
                          color: const Color(0xFF98A2B3),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              const BorderSide(color: Color(0xFFD0D5DD)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              const BorderSide(color: Color(0xFFD0D5DD)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              const BorderSide(color: Color(0xFF87C4F2)),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    InkWell(
                      onTap: isUploading ? null : handleUpload,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        width: 120.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              color: const Color(0xFF667085),
                              size: 20.sp,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              isUploading
                                  ? 'Uploading...'
                                  : 'Upload\nDocument',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF667085),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (fileName != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Uploaded: $fileName',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF12B76A),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                    SizedBox(height: 12.h),
                    Text(
                      'Our team will review your situation and decide if the cancellation penalty can be waived.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: (isSubmitting || isUploading)
                            ? null
                            : () async {
                                setState(() {
                                  isSubmitting = true;
                                });
                                final success = await _cancelBooking(
                                  parentContext,
                                  applicationId,
                                  reason: _emergencyPayloadReason,
                                  fileUrl: fileUrl,
                                );
                                if (!mounted) return;
                                if (success) {
                                  Navigator.of(dialogContext).pop();
                                  parentContext.pop();
                                  return;
                                }
                                setState(() {
                                  isSubmitting = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87C4F2),
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCancellationImpactDialog(
    BuildContext context,
    String applicationId,
  ) async {
    final parentContext = context;
    bool isSubmitting = false;

    await showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        icon: const Icon(Icons.close, color: Color(0xFF101828)),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                    Text(
                      'Cancellation Process',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101828),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You canceled your booking with The Smith Family.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Cancellation Impact:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101828),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildImpactRow(
                      'A note has been added to your profile.',
                    ),
                    _buildImpactRow(
                      'Future job recommendations may be impacted.',
                    ),
                    _buildImpactRow(
                      'Frequent cancellations could result in temporary account suspension.',
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Reach out to the family if you’d like to explain the cancellation.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                setState(() {
                                  isSubmitting = true;
                                });
                                final success = await _cancelBooking(
                                  parentContext,
                                  applicationId,
                                  reason: _standardPayloadReason,
                                );
                                if (!mounted) return;
                                if (success) {
                                  Navigator.of(dialogContext).pop();
                                  parentContext.pop();
                                  return;
                                }
                                setState(() {
                                  isSubmitting = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF87C4F2),
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Cancellation Confirmed',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
      },
    );
  }

  Widget _buildImpactRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: Color(0xFF101828),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF667085),
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _cancelBooking(
    BuildContext context,
    String applicationId, {
    required String reason,
    String? fileUrl,
  }) async {
    try {
      await ref.read(jobRequestRepositoryProvider).cancelBooking(
            applicationId,
            reason: reason,
            fileUrl: fileUrl,
          );
      ref.invalidate(sitterCurrentBookingsProvider);
      ref.invalidate(sitterBookingsProvider('upcoming'));
      ref.invalidate(sitterBookingsProvider(null));
      if (!mounted) return false;
      AppToast.show(context, 
        const SnackBar(content: Text('Booking cancelled successfully')),
      );
      return true;
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error cancelling booking: $e')),
        );
      }
      return false;
    }
  }

  Future<void> _showMarkCompleteDialog(
    BuildContext context,
    String applicationId,
    JobRequestDetailsModel jobDetails,
  ) async {
    final parentContext = context;
    await showDialog<void>(
      context: parentContext,
      useRootNavigator: true,
      builder: (dialogContext) {
        bool isSubmitting = false;
        return StatefulBuilder(
          builder: (context, setState) {
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
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '“Are You Sure That You Have\nCompleted This Job?”',
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
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            setState(() {
                              isSubmitting = true;
                            });
                            final success = await _markBookingComplete(
                              parentContext,
                              applicationId,
                              jobDetails,
                            );
                            if (!dialogContext.mounted) return;
                            if (success) {
                              Navigator.of(dialogContext).pop();
                              final reviewArgs =
                                  _buildReviewArgs(applicationId, jobDetails);
                              parentContext.push(
                                Routes.sitterReview,
                                extra: reviewArgs,
                              );
                              return;
                            }
                            setState(() {
                              isSubmitting = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87C4F2),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
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
                    onPressed: () => Navigator.of(dialogContext).pop(),
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
      },
    );
  }

  Future<bool> _markBookingComplete(
    BuildContext context,
    String applicationId,
    JobRequestDetailsModel jobDetails,
  ) async {
    try {
      _logCompleteBookingDebug(applicationId, jobDetails);
      await ref.read(jobRequestRepositoryProvider).completeBooking(
            applicationId,
          );
      ref.invalidate(jobRequestDetailsProvider(applicationId));
      ref.invalidate(sitterCurrentBookingsProvider);
      ref.invalidate(sitterBookingsProvider('upcoming'));
      ref.invalidate(sitterBookingsProvider('completed'));
      ref.invalidate(sitterBookingsProvider(null));
      if (!mounted) return false;
      AppToast.show(
        context,
        const SnackBar(content: Text('Job marked as complete')),
      );
      return true;
    } catch (e) {
      // If the error is 400 Bad Request with "Cannot complete this job", it likely means
      // the job is already in a state where it cannot be completed (e.g. already completed or cancelled).
      // In this case, we treat it as success to allow the user to proceed.
      final errorMessage = e.toString();
      if (errorMessage.contains('Cannot complete this job') ||
          errorMessage.contains('400')) {
        print('DEBUG: Handling 400 error as success (job likely already complete)');
        ref.invalidate(jobRequestDetailsProvider(applicationId));
        ref.invalidate(sitterCurrentBookingsProvider);
        if (!mounted) return false;
        AppToast.show(
          context,
          const SnackBar(content: Text('Job is already completed')),
        );
        return true;
      }

      if (mounted) {
        AppToast.show(
          context,
          SnackBar(content: Text('Error completing job: $e')),
        );
      }
      return false;
    }
  }

  void _logCompleteBookingDebug(
    String applicationId,
    JobRequestDetailsModel jobDetails,
  ) {
    final now = DateTime.now();
    final startDateTime = _parseStartDateTime(jobDetails);
    final endDateTime = _parseEndDateTime(jobDetails);
    print('=== COMPLETE BOOKING DEBUG ===');
    print('applicationId: $applicationId');
    print('jobId: ${jobDetails.id}');
    print('startDate: ${jobDetails.startDate}');
    print('endDate: ${jobDetails.endDate}');
    print('startTime: ${jobDetails.startTime}');
    print('endTime: ${jobDetails.endTime}');
    print('isToday: ${jobDetails.isToday}');
    print('canClockIn: ${jobDetails.canClockIn}');
    print('clockInMessage: ${jobDetails.clockInMessage}');
    print(
        'jobCoordinates: ${jobDetails.jobCoordinates?.latitude}, ${jobDetails.jobCoordinates?.longitude}');
    print('geofenceRadiusMeters: ${jobDetails.geofenceRadiusMeters}');
    print('now (local): $now');
    print('startDateTime (local): $startDateTime');
    print('endDateTime (local): $endDateTime');
    if (startDateTime != null) {
      print('isAfterStart: ${now.isAfter(startDateTime)}');
    }
    if (endDateTime != null) {
      print('isAfterEnd: ${now.isAfter(endDateTime)}');
    }
  }

  DateTime? _parseEndDateTime(JobRequestDetailsModel jobDetails) {
    final dateSource =
        jobDetails.endDate.isNotEmpty ? jobDetails.endDate : jobDetails.startDate;
    final date = _parseDate(dateSource);
    final minutes = _parseTimeToMinutes(jobDetails.endTime);
    if (date == null || minutes == null) {
      return null;
    }
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
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
      // Get device location for clock-in
      final position = await _getDeviceLocation();

      await ref.read(jobRequestRepositoryProvider).clockInBooking(
            applicationId,
            latitude: position['latitude'] as double,
            longitude: position['longitude'] as double,
          );
      if (!mounted) {
        return;
      }
      await ref
          .read(sessionTrackingControllerProvider.notifier)
          .loadSession(applicationId, forceRefresh: true);
      ref.invalidate(sitterCurrentBookingsProvider);
      ref.invalidate(sitterBookingsProvider('active'));
      ref.invalidate(sitterBookingsProvider('in_progress'));
      ref.invalidate(sitterBookingsProvider('upcoming'));
      await _showClockInDialog(context);
      if (mounted) {
        context.go('${Routes.sitterActiveBooking}/$applicationId');
      }
      ref.invalidate(jobRequestDetailsProvider(applicationId));
    } catch (e) {
      if (!mounted) {
        return;
      }
      AppToast.show(context, 
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

  Future<Map<String, double>> _getDeviceLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable them to clock in.');
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission is required to clock in.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permission is permanently denied. Please enable it in app settings.');
      }

      // Get current position with 30 second timeout
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 30),
        desiredAccuracy: LocationAccuracy.best,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      // Log error and show user-friendly message
      print('DEBUG: Location Error: $e');
      if (mounted) {
        AppToast.show(context, 
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      rethrow;
    }
  }

  /// DEBUG: Log current device location
  Future<void> _logDeviceLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('DEBUG DEVICE LOCATION: Location services disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('DEBUG DEVICE LOCATION: Permission denied');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
        desiredAccuracy: LocationAccuracy.best,
      );

      print('=== DEVICE LOCATION DEBUG ===');
      print('Device latitude: ${position.latitude}');
      print('Device longitude: ${position.longitude}');
      print('Device accuracy: ${position.accuracy} meters');
    } catch (e) {
      print('DEBUG DEVICE LOCATION ERROR: $e');
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

  ReviewArgs _buildReviewArgs(
    String applicationId,
    JobRequestDetailsModel jobDetails,
  ) {
    print('DEBUG _buildReviewArgs: ======= Building ReviewArgs =======');
    print('DEBUG _buildReviewArgs: applicationId = $applicationId');
    print('DEBUG _buildReviewArgs: jobDetails.id = ${jobDetails.id}');
    print('DEBUG _buildReviewArgs: jobDetails.familyName = "${jobDetails.familyName}"');
    print('DEBUG _buildReviewArgs: jobDetails.parentUserId = ${jobDetails.parentUserId}');
    print('DEBUG _buildReviewArgs: jobDetails.title = "${jobDetails.title}"');
    print('DEBUG _buildReviewArgs: jobDetails.location = ${jobDetails.location}');
    print('DEBUG _buildReviewArgs: jobDetails.familyPhotoUrl = ${jobDetails.familyPhotoUrl}');
    print('DEBUG _buildReviewArgs: jobDetails.jobId = ${jobDetails.jobId}');
    print('DEBUG _buildReviewArgs: jobDetails.sitterSkills = ${jobDetails.sitterSkills}');
    print('DEBUG _buildReviewArgs: Using jobId for review: ${jobDetails.jobId ?? jobDetails.id}');
    print('DEBUG _buildReviewArgs: =====================================');
    final hourlyRate = _formatCurrency(jobDetails.payRate);
    final timeRange = [
      _formatTime(jobDetails.startTime),
      _formatTime(jobDetails.endTime),
    ].where((value) => value.isNotEmpty).join(' - ');
    final dateRange = jobDetails.startDate == jobDetails.endDate
        ? _formatScheduledDate(jobDetails.startDate)
        : '${_formatScheduledDate(jobDetails.startDate)} - ${_formatScheduledDate(jobDetails.endDate)}';
    final sitterData = BookingDetailsUiModel(
      sitterName: jobDetails.familyName,
      avatarUrl: '',
      isVerified: false,
      rating: '',
      responseRate: '',
      reliabilityRate: '',
      experience: '',
      distance: '',
      skills: const [],
      familyName: jobDetails.familyName,
      numberOfChildren: jobDetails.childrenCount.toString(),
      dateRange: dateRange,
      timeRange: timeRange,
      hourlyRate: '$hourlyRate/hour',
      numberOfDays: jobDetails.numberOfDays.toString(),
      additionalNotes: jobDetails.additionalNotes ?? '',
      address: jobDetails.fullAddress,
      subTotal: '',
      totalHours: '',
      platformFee: '',
      discount: '',
      estimatedTotalCost: '',
    );

    return ReviewArgs(
      bookingId: jobDetails.id,
      sitterId: jobDetails.parentUserId ?? '',
      sitterName: jobDetails.familyName,
      sitterData: sitterData,
      status: BookingStatus.completed,
      jobTitle: jobDetails.title,
      location: jobDetails.location,
      familyName: jobDetails.familyName,
      childrenCount: jobDetails.childrenCount.toString(),
      paymentLabel: '$hourlyRate/hour',
      avatarUrl: jobDetails.familyPhotoUrl,
      reviewPrompt: 'Rate Your Experience With This Family\n(Private).',
      jobId: jobDetails.jobId ?? jobDetails.id, // Use jobId if available, fallback to id
    );
  }

}

class _ClockInState {
  final bool canClockIn;
  final String? message;

  const _ClockInState({required this.canClockIn, this.message});
}
