/// Interface for notification services
abstract interface class NotificationsService {
  /// Initialize the notification service
  Future<void> initialize();

  /// Request notification permissions
  Future<bool> requestPermission();

  /// Get the FCM token
  Future<String?> getToken();

  /// Force refresh the FCM token (delete old token and request a new one)
  Future<String?> forceRefreshToken();

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic);

  /// Show a local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  });

  /// Stream of notification taps (payload)
  Stream<String?> get onNotificationTap;

  /// Stream of FCM token refreshes
  Stream<String> get onTokenRefresh;

  /// Run diagnostics to check the notification pipeline
  Future<void> runDiagnostics();

  /// Dispose resources
  void dispose();
}
