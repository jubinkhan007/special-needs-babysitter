/// Interface for notification services
abstract interface class NotificationsService {
  /// Initialize the notification service
  Future<void> initialize();

  /// Request notification permissions
  Future<bool> requestPermission();

  /// Get the FCM token
  Future<String?> getToken();

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

  /// Dispose resources
  void dispose();
}
