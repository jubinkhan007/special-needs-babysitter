import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/bookings_data_di.dart';
import '../../data/datasources/google_geocoding_remote_datasource.dart';
import '../../domain/booking_location.dart';
import '../models/route_stop_ui_model.dart';
import 'booking_location_provider.dart';

final bookingRouteStopsProvider =
    FutureProvider.family<List<RouteStopUiModel>, String>((ref, bookingId) async {
  final location = await ref.watch(bookingLocationProvider(bookingId).future);
  final geocoder = ref.watch(googleGeocodingRemoteDataSourceProvider);
  final points = location.routeCoordinates;
  final visiblePoints =
      points.length > 5 ? points.sublist(points.length - 5) : points;

  if (visiblePoints.isEmpty && location.currentLocation != null) {
    final stop = await _buildStop(
      geocoder: geocoder,
      point: location.currentLocation!,
      isActive: true,
      isLast: true,
    );
    return [stop];
  }

  if (visiblePoints.isEmpty) {
    return const [];
  }

  final stops = <RouteStopUiModel>[];
  for (var i = 0; i < visiblePoints.length; i++) {
    final isLast = i == visiblePoints.length - 1;
    stops.add(
      await _buildStop(
        geocoder: geocoder,
        point: visiblePoints[i],
        isActive: isLast,
        isLast: isLast,
      ),
    );
  }
  return stops;
});

Future<RouteStopUiModel> _buildStop({
  required GoogleGeocodingRemoteDataSource geocoder,
  required BookingLocationPoint point,
  required bool isActive,
  required bool isLast,
}) async {
  final address = await geocoder.reverseGeocode(
    latitude: point.latitude,
    longitude: point.longitude,
  );
  final timeLabel = point.timestamp != null
      ? DateFormat('h:mm a').format(point.timestamp!.toLocal())
      : '';
  return RouteStopUiModel(
    addressLine: address ??
        '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
    timeLabel: timeLabel,
    isActive: isActive,
    isLast: isLast,
  );
}
