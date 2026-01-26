import 'package:geolocator/geolocator.dart';

enum LocationAccessStatus {
  available,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationHelper {
  static const double defaultLatitude = 36.1627; // Nashville
  static const double defaultLongitude = -86.7816; // Nashville
  static const int timeoutSeconds = 5;

  // Cache location for session
  static double? _cachedLatitude;
  static double? _cachedLongitude;

  static Future<LocationAccessStatus> getStatus() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return LocationAccessStatus.serviceDisabled;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return LocationAccessStatus.permissionDenied;
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationAccessStatus.permissionDeniedForever;
    }
    return LocationAccessStatus.available;
  }

  static Future<LocationAccessStatus> requestPermission() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return LocationAccessStatus.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationAccessStatus.permissionDeniedForever;
    }
    if (permission == LocationPermission.denied) {
      return LocationAccessStatus.permissionDenied;
    }
    return LocationAccessStatus.available;
  }

  static Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  static Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Get device's current location with permission handling
  /// Returns (latitude, longitude) or default Nashville coordinates if unavailable
  static Future<(double, double)> getLocation({
    bool requestPermission = true,
  }) async {
    // Check if location is cached
    if (_cachedLatitude != null && _cachedLongitude != null) {
      return (_cachedLatitude!, _cachedLongitude!);
    }

    try {
      // Check location services enabled
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        return (defaultLatitude, defaultLongitude);
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied && requestPermission) {
        // Request permission
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permission denied
        return (defaultLatitude, defaultLongitude);
      }

      // Get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: timeoutSeconds),
        forceAndroidLocationManager: false,
      );

      // Cache the location
      _cachedLatitude = position.latitude;
      _cachedLongitude = position.longitude;

      return (position.latitude, position.longitude);
    } catch (e) {
      // On any error, return default location
      return (defaultLatitude, defaultLongitude);
    }
  }

  /// Clear cached location (useful for manual refresh)
  static void clearCache() {
    _cachedLatitude = null;
    _cachedLongitude = null;
  }

  /// Manually set location (for testing or manual override)
  static void setLocation(double latitude, double longitude) {
    _cachedLatitude = latitude;
    _cachedLongitude = longitude;
  }
}
