import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_location.dart';
import '../models/route_stop_ui_model.dart';
import '../providers/booking_location_provider.dart';
import '../providers/booking_route_stops_provider.dart';
import 'widgets/map_route_app_bar.dart';
import 'widgets/route_stops_card.dart';

class MapRouteScreen extends ConsumerWidget {
  final String bookingId;

  const MapRouteScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(bookingLocationProvider(bookingId));
    final stopsAsync = ref.watch(bookingRouteStopsProvider(bookingId));
    final resolvedStops = stopsAsync.maybeWhen(
      data: (stops) => stops.isNotEmpty
          ? stops
          : const [
              RouteStopUiModel(
                addressLine: 'No route data yet',
                timeLabel: '',
                isActive: true,
                isLast: true,
              ),
            ],
      orElse: () => const [
        RouteStopUiModel(
          addressLine: 'Loading route...',
          timeLabel: '',
          isActive: true,
          isLast: true,
        ),
      ],
    );

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.surfaceWhite,
        body: Stack(
          children: [
            // 1. Map Background (Full Screen)
            Positioned.fill(
              child: locationAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => _buildMapPlaceholder(),
                data: (location) => _buildMap(location),
              ),
            ),

            // 2. App Bar Overlay (Top)
            const Align(
              alignment: Alignment.topCenter,
              child: MapRouteAppBar(),
            ),

            // 3. Bottom Route Card Overlay
            Positioned(
              left: AppTokens.routeCardMarginHorizontal,
              right: AppTokens.routeCardMarginHorizontal,
              bottom:
                  AppTokens.routeCardBottomInset, // Lifted above bottom edge
              child: SafeArea(
                top: false, // Don't care about top safe area here
                child: RouteStopsCard(stops: resolvedStops),
              ),
            ),
          ],
        ),
      ),
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
      return _buildMapPlaceholder();
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

  Widget _buildMapPlaceholder() {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Map View',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
