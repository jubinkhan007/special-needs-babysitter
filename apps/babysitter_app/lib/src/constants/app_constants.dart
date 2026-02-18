import 'package:core/core.dart';

/// App-level constants that re-export from core for convenience
class AppConstants {
  /// Single source of truth for API base URL - from core package
  static String get baseUrl => EnvConfig.apiBaseUrl;
}
