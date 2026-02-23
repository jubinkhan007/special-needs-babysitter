class BookingLocationResponseDto {
  final bool success;
  final BookingLocationDto data;

  BookingLocationResponseDto({
    required this.success,
    required this.data,
  });

  factory BookingLocationResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingLocationResponseDto(
      success: json['success'] == true,
      data: BookingLocationDto.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}

class BookingLocationDto {
  final BookingLocationPointDto? currentLocation;
  final List<BookingLocationPointDto> routeCoordinates;
  final double? distance;
  final String? status;
  final bool? isPaused;
  final DateTime? pausedAt;
  final String? currentBreakReason;
  final DateTime? clockInTime;

  BookingLocationDto({
    required this.currentLocation,
    required this.routeCoordinates,
    this.distance,
    this.status,
    this.isPaused,
    this.pausedAt,
    this.currentBreakReason,
    this.clockInTime,
  });

  factory BookingLocationDto.fromJson(Map<String, dynamic> json) {
    final current = json['currentLocation'];
    final route = json['routeCoordinates'] as List?;
    return BookingLocationDto(
      currentLocation: current is Map<String, dynamic>
          ? BookingLocationPointDto.fromJson(current)
          : null,
      routeCoordinates: route
              ?.whereType<Map<String, dynamic>>()
              .map(BookingLocationPointDto.fromJson)
              .toList() ??
          const [],
      distance: _parseDouble(json['distance']),
      status: json['status'] as String?,
      isPaused: json['isPaused'] as bool?,
      pausedAt: _parseDateTime(json['pausedAt']),
      currentBreakReason: json['currentBreakReason'] as String?,
      clockInTime: _parseDateTime(json['clockInTime']),
    );
  }
}

class BookingLocationPointDto {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  BookingLocationPointDto({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  factory BookingLocationPointDto.fromJson(Map<String, dynamic> json) {
    return BookingLocationPointDto(
      latitude: _parseDouble(json['latitude']) ?? 0,
      longitude: _parseDouble(json['longitude']) ?? 0,
      timestamp: _parseDateTime(json['timestamp']),
    );
  }
}

double? _parseDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed);
  }
  return null;
}
