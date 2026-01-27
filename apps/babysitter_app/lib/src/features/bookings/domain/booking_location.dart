class BookingLocationPoint {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  const BookingLocationPoint({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });
}

class BookingLocation {
  final BookingLocationPoint? currentLocation;
  final List<BookingLocationPoint> routeCoordinates;
  final double? distance;
  final String? status;
  final bool? isPaused;
  final DateTime? pausedAt;
  final String? currentBreakReason;
  final DateTime? clockInTime;

  const BookingLocation({
    required this.currentLocation,
    required this.routeCoordinates,
    this.distance,
    this.status,
    this.isPaused,
    this.pausedAt,
    this.currentBreakReason,
    this.clockInTime,
  });
}
