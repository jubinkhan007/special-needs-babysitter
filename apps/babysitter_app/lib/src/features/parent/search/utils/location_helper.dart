import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static const double defaultLatitude = 36.1627; // Nashville
  static const double defaultLongitude = -86.7816; // Nashville
  static const int timeoutSeconds = 5;

  // Cache location for session
  static double? _cachedLatitude;
  static double? _cachedLongitude;

  /// Get device's current location with permission handling
  /// Returns (latitude, longitude) or default Nashville coordinates if unavailable
  static Future<(double, double)> getLocation() async {
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

      if (permission == LocationPermission.denied) {
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
