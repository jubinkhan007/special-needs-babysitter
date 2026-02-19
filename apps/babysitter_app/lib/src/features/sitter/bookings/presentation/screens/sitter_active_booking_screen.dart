import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/booking_session_model.dart';
import '../../data/models/booking_model.dart';
import '../../../../bookings/data/bookings_data_di.dart';
import '../../../jobs/data/models/job_coordinates_model.dart';
import '../../../jobs/data/models/job_request_details_model.dart';
import '../../../jobs/presentation/providers/job_request_providers.dart';
import '../controllers/session_tracking_controller.dart';
import '../providers/bookings_providers.dart';
import '../providers/session_tracking_providers.dart';
import '../widgets/break_timer_dialog.dart';
import '../widgets/pause_clock_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/routing/routes.dart';

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
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  double _mapZoom = 14.0;
  bool _useSatelliteView = false;
  DateTime? _lastShiftEndReminderDate;
  bool _isShiftEndDialogShowing = false;
  bool _hasStatusRedirected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sessionTrackingControllerProvider.notifier)
          .loadSession(widget.applicationId, forceRefresh: true);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _zoomIn() async {
    if (!_isMapReady || _mapController == null) return;
    try {
      final currentZoom = await _mapController!.getZoomLevel();
      await _mapController!.animateCamera(CameraUpdate.zoomTo(currentZoom + 1));
    } catch (e) {
      debugPrint('Error zooming in: $e');
    }
  }

  Future<void> _zoomOut() async {
    if (!_isMapReady || _mapController == null) return;
    try {
      final currentZoom = await _mapController!.getZoomLevel();
      await _mapController!.animateCamera(CameraUpdate.zoomTo(currentZoom - 1));
    } catch (e) {
      debugPrint('Error zooming out: $e');
    }
  }

  void _centerOnLocation(LatLng? location) {
    if (!_isMapReady || _mapController == null || location == null) return;
    _mapController!.animateCamera(CameraUpdate.newLatLng(location));
  }

  void _toggleMapType() {
    setState(() => _useSatelliteView = !_useSatelliteView);
  }

  Future<void> _togglePause() async {
    final session = ref.read(sessionTrackingControllerProvider).session;
    if (session == null) return;

    if (session.isPaused) {
      showDialog(
        context: context,
        builder: (context) => BreakTimerDialog(
          pausedAt: session.pausedAt ?? DateTime.now(),
          onResume: () async {
            Navigator.of(context).pop();
            await ref
                .read(sessionTrackingControllerProvider.notifier)
                .resumeSession();
          },
          onEndBreak: () async {
            Navigator.of(context).pop();
            await ref
                .read(sessionTrackingControllerProvider.notifier)
                .resumeSession();
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      // Show confirmation dialog before pausing
      showDialog(
        context: context,
        builder: (context) => PauseClockDialog(
          onPause: () async {
            Navigator.of(context).pop();
            await ref
                .read(sessionTrackingControllerProvider.notifier)
                .togglePause(breakReason: "Lunch break");
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  Future<void> _clockOut() async {
    setState(() => _isClockingOut = true);

    try {
      if (mounted) {
        final result = await ref
            .read(sessionTrackingControllerProvider.notifier)
            .clockOut(widget.applicationId);
        final jobDetails =
            ref.read(jobRequestDetailsProvider(widget.applicationId)).valueOrNull;
        final isFinalDay = result.isFinalDay || _isFinalDay(jobDetails);
        AppToast.show(
          context,
          SnackBar(
            content: Text(result.message.isNotEmpty
                ? result.message
                : 'Successfully clocked out!'),
            backgroundColor: AppColors.success,
          ),
        );
        if (isFinalDay) {
          _goToBookingDetails(status: 'clockedout');
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString().replaceFirst('Exception: ', '');
        if (message.contains('Cannot clock out from this booking')) {
          AppToast.show(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.warning,
            ),
          );
          final jobDetails = ref
              .read(jobRequestDetailsProvider(widget.applicationId))
              .valueOrNull;
          final bookings =
              ref.read(sitterCurrentBookingsProvider).valueOrNull;
          final bookingStatus =
              _findBookingStatus(bookings, widget.applicationId);
          final effectiveStatus =
              _resolveApplicationStatus(jobDetails, bookingStatus);
          if (jobDetails != null &&
              _hasFinalEndPassed(jobDetails, DateTime.now())) {
            _goToBookingDetails(status: 'completed');
          } else if (effectiveStatus != null &&
              effectiveStatus.trim().isNotEmpty) {
            _goToBookingDetails(status: effectiveStatus);
          } else {
            _goToBookingDetails();
          }
          return;
        }
        AppToast.show(
          context,
          SnackBar(
            content: Text(
                'Failed to clock out: ${e.toString().replaceFirst("Exception: ", "")}'),
            backgroundColor: AppColors.error,
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
    final jobDetailsAsync =
        ref.watch(jobRequestDetailsProvider(widget.applicationId));
    final bookingsAsync = ref.watch(sitterCurrentBookingsProvider);

    // Listen for location updates to move map camera
    ref.listen(sessionTrackingControllerProvider, (previous, next) {
      final prevPoints = previous?.routeCoordinates ?? [];
      final nextPoints = next.routeCoordinates;

      if (!_isMapReady || _mapController == null) {
        return;
      }

      if (nextPoints.isNotEmpty && nextPoints.length > prevPoints.length) {
        final lastPoint = nextPoints.last;
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(lastPoint.latitude, lastPoint.longitude),
          ),
        );
      }
    });

    final now = ref.watch(sessionTickerProvider).maybeWhen(
          data: (value) => value,
          orElse: () => DateTime.now(),
        );
    final session = trackingState.session;
    final jobDetails = jobDetailsAsync.valueOrNull;
    final bookingStatus =
        _findBookingStatus(bookingsAsync.valueOrNull, widget.applicationId);
    final effectiveStatus =
        _resolveApplicationStatus(jobDetails, bookingStatus);
    _maybeRedirectIfClockedOut(effectiveStatus, jobDetails, session, now);
    if (session != null) {
      final shiftEnd = _resolveShiftEndDateTime(now, session, jobDetails);
      _maybeShowShiftEndReminder(now, shiftEnd);
    }

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
        'Active Booking',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.buttonDark,
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
        session.isPaused ? AppColors.warning : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Session',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.buttonDark,
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
            color: AppColors.surfaceTint,
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
            color: AppColors.buttonDark,
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
              color: AppColors.buttonDark,
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
    final trackingLabel =
        trackingState.isTracking ? 'Tracking on' : 'Tracking off';
    final trackingColor = trackingState.isTracking
        ? const Color(0xFF12B76A)
        : const Color(0xFFF04438);
    final session = trackingState.session;
    final destination = session?.coordinates;
    final routePoints = trackingState.routeCoordinates
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    final center = routePoints.isNotEmpty
        ? routePoints.last
        : (destination != null
            ? LatLng(destination.latitude, destination.longitude)
            : null);

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
                color: AppColors.buttonDark,
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
            child: center == null
                ? Container(
                    color: const Color(0xFFE8F4F8),
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 64.w,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: center,
                          zoom: 14.0,
                        ),
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (mounted) {
                            setState(() {
                              _isMapReady = true;
                            });
                          }
                        },
                        onCameraMove: (position) {
                          _mapZoom = position.zoom;
                        },
                        mapType: _useSatelliteView
                            ? MapType.hybrid
                            : MapType.normal,
                        polylines: {
                          if (routePoints.length >= 2)
                            Polyline(
                              polylineId: const PolylineId('route'),
                              points: routePoints,
                              width: 4,
                              color: const Color(0xFF3B82F6),
                            ),
                        },
                        markers: {
                          if (routePoints.isNotEmpty)
                            Marker(
                              markerId: const MarkerId('current'),
                              position: routePoints.last,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure),
                            ),
                          if (destination != null)
                            Marker(
                              markerId: const MarkerId('destination'),
                              position: LatLng(destination.latitude,
                                  destination.longitude),
                            ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                      ),
                      // Map Controls Overlay
                      Positioned(
                        right: 8.w,
                        top: 8.h,
                        child: Column(
                          children: [
                            // Map type toggle
                            _buildMapControlButton(
                              icon: _useSatelliteView
                                  ? Icons.map_outlined
                                  : Icons.layers_outlined,
                              onTap: _toggleMapType,
                              tooltip: _useSatelliteView
                                  ? 'Standard view'
                                  : 'Terrain view',
                            ),
                            SizedBox(height: 8.h),
                            // Re-center button
                            _buildMapControlButton(
                              icon: Icons.my_location,
                              onTap: () => _centerOnLocation(
                                  routePoints.isNotEmpty
                                      ? routePoints.last
                                      : center),
                              tooltip: 'Center on location',
                            ),
                          ],
                        ),
                      ),
                      // Zoom controls (bottom right)
                      Positioned(
                        right: 8.w,
                        bottom: 8.h,
                        child: Column(
                          children: [
                            _buildMapControlButton(
                              icon: Icons.add,
                              onTap: _zoomIn,
                              tooltip: 'Zoom in',
                            ),
                            SizedBox(height: 4.h),
                            _buildMapControlButton(
                              icon: Icons.remove,
                              onTap: _zoomOut,
                              tooltip: 'Zoom out',
                            ),
                          ],
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
            color: AppColors.buttonDark,
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
            color: AppColors.primary,
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.buttonDark,
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

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
          ),
          child: Icon(
            icon,
            size: 20.w,
            color: const Color(0xFF667085),
          ),
        ),
      ),
    );
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
                  color: AppColors.buttonDark,
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
                    separatorBuilder: (context, index) => Divider(height: 16.h),
                    itemBuilder: (context, index) {
                      // Show newest first
                      final reverseIndex = route.length - 1 - index;
                      final point = route[reverseIndex];
                      return _RoutePointItem(
                        index: reverseIndex + 1,
                        point: point,
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
            child: Container(
              height: 56.h,
              padding: EdgeInsets.only(bottom: 4.h),
              child: ElevatedButton(
                onPressed: _isClockingOut ? null : _clockOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.zero,
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
                          height: 1.2,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Copy/Share Button
          Container(
            width: 56.h,
            height: 56.h,
            padding: EdgeInsets.only(bottom: 4.h),
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

  void _maybeShowShiftEndReminder(DateTime now, DateTime? shiftEnd) {
    if (shiftEnd == null) {
      return;
    }
    final today = DateTime(now.year, now.month, now.day);
    if (_lastShiftEndReminderDate != null &&
        _isSameDate(_lastShiftEndReminderDate!, today)) {
      return;
    }
    final reminderTime = shiftEnd.subtract(const Duration(minutes: 5));
    final withinWindow =
        (now.isAfter(reminderTime) || now.isAtSameMomentAs(reminderTime)) &&
            (now.isBefore(shiftEnd) || now.isAtSameMomentAs(shiftEnd));
    if (!withinWindow || _isShiftEndDialogShowing) {
      return;
    }
    _isShiftEndDialogShowing = true;
    _lastShiftEndReminderDate = today;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _showShiftEndDialog();
      if (!mounted) return;
      setState(() => _isShiftEndDialogShowing = false);
    });
  }

  Future<void> _showShiftEndDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF667085)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your shift ends soon. Please remember to clock out!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
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

  String? _findBookingStatus(
    List<BookingModel>? bookings,
    String applicationId,
  ) {
    if (bookings == null || bookings.isEmpty) {
      return null;
    }
    for (final booking in bookings) {
      if (booking.applicationId == applicationId) {
        return booking.status;
      }
    }
    return null;
  }

  String? _resolveApplicationStatus(
    JobRequestDetailsModel? jobDetails,
    String? bookingStatus,
  ) {
    if (bookingStatus != null && bookingStatus.trim().isNotEmpty) {
      return bookingStatus;
    }
    final fallback = jobDetails?.status.trim();
    return (fallback != null && fallback.isNotEmpty) ? fallback : null;
  }

  void _maybeRedirectIfClockedOut(
    String? status,
    JobRequestDetailsModel? jobDetails,
    BookingSessionModel? session,
    DateTime now,
  ) {
    if (_hasStatusRedirected || status == null || status.trim().isEmpty) {
      return;
    }
    final normalized =
        status.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (normalized != 'clockedout' && normalized != 'completed') {
      return;
    }
    _hasStatusRedirected = true;
    if (session != null) {
      ref.read(sessionTrackingControllerProvider.notifier).stopSession();
    }
    final shouldComplete = normalized == 'completed' ||
        (jobDetails != null && _hasFinalEndPassed(jobDetails, now));
    final targetStatus = shouldComplete ? 'completed' : status;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _goToBookingDetails(status: targetStatus);
    });
  }

  void _goToBookingDetails({String? status}) {
    final query = status != null && status.trim().isNotEmpty
        ? '?status=${Uri.encodeComponent(status)}'
        : '';
    context.go('${Routes.sitterBookingDetails}/${widget.applicationId}$query');
  }

  DateTime? _resolveShiftEndDateTime(
    DateTime now,
    BookingSessionModel session,
    JobRequestDetailsModel? jobDetails,
  ) {
    if (jobDetails != null) {
      final activeDate = _resolveActiveDate(jobDetails, now);
      final endMinutes = _parseTimeToMinutes(jobDetails.endTime);
      if (activeDate != null && endMinutes != null) {
        return DateTime(
          activeDate.year,
          activeDate.month,
          activeDate.day,
          endMinutes ~/ 60,
          endMinutes % 60,
        );
      }
    }
    return session.scheduledEndTime?.toLocal();
  }

  DateTime? _resolveActiveDate(JobRequestDetailsModel jobDetails, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final start = _parseDate(jobDetails.startDate);
    final end = _parseDate(jobDetails.endDate);
    if (start != null && end != null) {
      final startsBeforeOrToday =
          _isSameDate(today, start) || today.isAfter(start);
      final endsAfterOrToday =
          _isSameDate(today, end) || today.isBefore(end);
      if (startsBeforeOrToday && endsAfterOrToday) {
        return today;
      }
    }
    return start;
  }

  int? _parseTimeToMinutes(String value) {
    try {
      final trimmed = value.trim();
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

  DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    try {
      final parsed = DateTime.parse(trimmed);
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      return null;
    }
  }

  bool _hasFinalEndPassed(JobRequestDetailsModel jobDetails, DateTime now) {
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
    return now.isAfter(endDateTime) || now.isAtSameMomentAs(endDateTime);
  }

  bool _isFinalDay(JobRequestDetailsModel? jobDetails) {
    if (jobDetails == null) {
      return false;
    }
    final end = _parseDate(jobDetails.endDate);
    if (end == null) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _isSameDate(today, end);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _RoutePointItem extends ConsumerStatefulWidget {
  final int index;
  final JobCoordinatesModel point;

  const _RoutePointItem({
    required this.index,
    required this.point,
  });

  @override
  ConsumerState<_RoutePointItem> createState() => _RoutePointItemState();
}

class _RoutePointItemState extends ConsumerState<_RoutePointItem> {
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    try {
      final geocoder = ref.read(googleGeocodingRemoteDataSourceProvider);
      final address = await geocoder.reverseGeocode(
        latitude: widget.point.latitude,
        longitude: widget.point.longitude,
      );
      
      if (mounted) {
        setState(() {
          _address = address;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.point.latitude.toStringAsFixed(5);
    final lng = widget.point.longitude.toStringAsFixed(5);
    final fallback = '$lat, $lng';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.index}. ${_isLoading ? "Loading address..." : (_address ?? fallback)}',
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF344054),
            fontFamily: 'Inter',
          ),
        ),
        if (!_isLoading && _address != null)
          Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: Text(
              '($lat, $lng)',
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF98A2B3),
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }
}
