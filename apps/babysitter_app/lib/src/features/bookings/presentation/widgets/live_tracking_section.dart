import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../routing/routes.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_location.dart';
import '../providers/booking_location_provider.dart';

class LiveTrackingSection extends ConsumerWidget {
  final String bookingId;

  const LiveTrackingSection({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(bookingLocationProvider(bookingId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Tracking',
                style: AppTokens.activeSectionTitle,
              ),
              GestureDetector(
                onTap: () {
                  context.push(Routes.mapRoute, extra: bookingId);
                },
                child: Text(
                  'Open in Maps',
                  style: AppTokens.linkTextStyle,
                ),
              ),
            ],
          ),
        ),

        // Map Card
        Container(
          height: AppTokens.mapHeight,
          decoration: BoxDecoration(
            color: AppTokens.mapCardBg,
            borderRadius: BorderRadius.circular(AppTokens.mapCardRadius),
            boxShadow: AppTokens.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTokens.mapCardRadius),
            child: locationAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _buildPlaceholder(),
              data: (location) => _buildMap(location),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap(BookingLocation location) {
    final routePoints = location.routeCoordinates
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    final current = location.currentLocation;
    final center = current != null
        ? LatLng(current.latitude, current.longitude)
        : (routePoints.isNotEmpty ? routePoints.last : null);

    if (center == null) {
      return _buildPlaceholder();
    }

    final polylines = <Polyline>{};
    if (routePoints.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          width: 4,
          color: const Color(0xFF3B82F6),
        ),
      );
    }

    final markers = <Marker>{};
    if (current != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: LatLng(current.latitude, current.longitude),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: center, zoom: 14.0),
      markers: markers,
      polylines: polylines,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE5E5E5),
      child: Center(
        child: Icon(Icons.map, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}
