/// Application-wide constants
class Constants {
  Constants._();

  // API Configuration
  static const String baseUrl =
      'https://babysitter-backend.waywisetech.com/api/';

  // App info
  static const String appName = 'Special Needs Sitters';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Notification channels
  static const String notificationChannelId = 'special_needs_sitters_channel';
  static const String notificationChannelName = 'Special Needs Sitters';
  static const String notificationChannelDescription =
      'Notifications from Special Needs Sitters';
}
