import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/booking_session_model.dart';
import '../controllers/session_tracking_controller.dart';
import '../providers/session_tracking_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Sitter Active Booking Screen - Shown when a sitter is on an active session
class SitterActiveBookingScreen extends ConsumerStatefulWidget {
  final String applicationId;

  const SitterActiveBookingScreen({
    super.key,
    required this.applicationId,
  });

  @override
  ConsumerState<SitterActiveBookingScreen> createState() =>
      _SitterActiveBookingScreenState();
}

class _SitterActiveBookingScreenState
    extends ConsumerState<SitterActiveBookingScreen> {
  bool _isClockingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sessionTrackingControllerProvider.notifier)
          .loadSession(widget.applicationId, forceRefresh: true);
    });
  }

  void _togglePause() {
    ref.read(sessionTrackingControllerProvider.notifier).togglePause();
  }

  Future<void> _clockOut() async {
    setState(() => _isClockingOut = true);

    try {
      // TODO: Integrate with actual clock-out API
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        await ref
            .read(sessionTrackingControllerProvider.notifier)
            .stopSession();
        AppToast.show(
          context,
          const SnackBar(
            content: Text('Successfully clocked out!'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          SnackBar(
            content: Text(
                'Failed to clock out: ${e.toString().replaceFirst("Exception: ", "")}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isClockingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(sessionTrackingControllerProvider);
    final now = ref.watch(sessionTickerProvider).maybeWhen(
          data: (value) => value,
          orElse: () => DateTime.now(),
        );
    final session = trackingState.session;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: trackingState.isLoading && session == null
          ? const Center(child: CircularProgressIndicator())
          : trackingState.errorMessage != null && session == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${trackingState.errorMessage}'),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(sessionTrackingControllerProvider.notifier)
                            .loadSession(widget.applicationId,
                                forceRefresh: true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : session == null
                  ? const Center(child: Text('Session not available'))
                  : _buildContent(context, session, now, trackingState),
      bottomNavigationBar: _buildBottomBar(context),
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
        'Active Booking',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1D2939),
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.headset_mic_outlined,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () {
            // TODO: Open support
          },
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    BookingSessionModel session,
    DateTime now,
    SessionTrackingState trackingState,
  ) {
    final elapsed = session.elapsedTime(now);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // Active Session Section
          _buildActiveSessionSection(session, elapsed),

          SizedBox(height: 24.h),

          // Live Tracking Section
          _buildLiveTrackingSection(trackingState),

          SizedBox(height: 24.h),

          // Children Info Section
          _buildChildrenInfoSection(session),

          SizedBox(height: 100.h), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildActiveSessionSection(
      BookingSessionModel session, Duration elapsed) {
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final statusLabel = session.isPaused ? 'Paused' : 'Active';
    final statusColor =
        session.isPaused ? const Color(0xFFF59E0B) : const Color(0xFF22C55E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Session',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 16.h),
        if (session.jobTitle.isNotEmpty || session.familyName.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              [session.jobTitle, session.familyName]
                  .where((value) => value.isNotEmpty)
                  .join(' • '),
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF667085),
                fontFamily: 'Inter',
              ),
            ),
          ),

        // Timer Card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE0F2FE)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hours
              _buildTimeUnit(hours, 'Hour'),
              _buildTimeSeparator(),
              // Minutes
              _buildTimeUnit(minutes, 'Minute'),
              _buildTimeSeparator(),
              // Seconds with Active badge
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildTimeBox(seconds),
                      Positioned(
                        top: -8.h,
                        right: -20.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Seconds',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              // Pause Button
              GestureDetector(
                onTap: _togglePause,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    session.isPaused ? Icons.play_arrow : Icons.pause,
                    color: const Color(0xFF667085),
                    size: 24.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        _buildTimeBox(value),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF667085),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0F2FE)),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Text(
            ':',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D2939),
            ),
          ),
          SizedBox(height: 20.h), // Align with time boxes
        ],
      ),
    );
  }

  Widget _buildLiveTrackingSection(SessionTrackingState trackingState) {
    final routeCount = trackingState.routeCoordinates.length;
    final lastUpdate = trackingState.lastLocationAt;
    final trackingLabel = trackingState.isTracking ? 'Tracking on' : 'Tracking off';
    final trackingColor = trackingState.isTracking
        ? const Color(0xFF12B76A)
        : const Color(0xFFF04438);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Live Tracking',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D2939),
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () {
                _showRouteDetails(context, trackingState);
              },
              child: Text(
                'View Routes',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: trackingColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                trackingLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: trackingColor,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '$routeCount points',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF667085),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Map placeholder
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                // Placeholder map image
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 64.w,
                      color: const Color(0xFF87C4F2),
                    ),
                  ),
                ),
                // Route line overlay (simulated)
                Positioned(
                  top: 40.h,
                  left: 60.w,
                  child: Container(
                    width: 200.w,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Destination marker
                Positioned(
                  top: 30.h,
                  right: 40.w,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: const Color(0xFF1D2939),
                      size: 20.w,
                    ),
                  ),
                ),
                // Current location marker
                Positioned(
                  bottom: 50.h,
                  left: 40.w,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Location visibility text
        Text(
          trackingState.locationWarning ??
              (trackingState.isTracking
                  ? 'Your location is now visible to the family.'
                  : 'Live tracking is paused. Enable location to continue.'),
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF667085),
            fontFamily: 'Inter',
          ),
        ),
        if (lastUpdate != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              'Last update: ${_formatTime(lastUpdate)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF98A2B3),
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChildrenInfoSection(BookingSessionModel session) {
    final children = session.children;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Children Info',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 12.h),

        // Horizontal scrollable children list
        SizedBox(
          height: 90.h,
          child: children.isEmpty
              ? Center(
                  child: Text(
                    'No children info available',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF667085),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: children.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return _buildChildCard(
                      name: child.firstName,
                      icon: _getChildIcon(index),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChildCard({required String name, required IconData icon}) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28.w,
            color: const Color(0xFF87C4F2),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D2939),
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getChildIcon(int index) {
    final icons = [
      Icons.child_care,
      Icons.face,
      Icons.pets,
      Icons.sports_soccer,
    ];
    return icons[index % icons.length];
  }

  void _showRouteDetails(
      BuildContext context, SessionTrackingState trackingState) {
    final route = trackingState.routeCoordinates;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Route Updates',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D2939),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 12.h),
              if (route.isEmpty)
                Text(
                  'No route updates yet.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF667085),
                  ),
                )
              else
                SizedBox(
                  height: 280.h,
                  child: ListView.separated(
                    itemCount: route.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 16.h),
                    itemBuilder: (context, index) {
                      final point = route[index];
                      return Text(
                        '${index + 1}. ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF344054),
                          fontFamily: 'Inter',
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Clock Out Button
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isClockingOut ? null : _clockOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87C4F2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: _isClockingOut
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Clock Out',
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
          // Copy/Share Button
          Container(
            width: 52.h,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Copy/Share functionality
              },
              icon: Icon(
                Icons.copy_outlined,
                color: const Color(0xFF667085),
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
