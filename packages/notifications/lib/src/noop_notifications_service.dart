import 'dart:async';
import 'dart:developer' as developer;

import 'notifications_service.dart';

/// No-op implementation for when Firebase is not configured
class NoopNotificationsService implements NotificationsService {
  final _notificationTapController = StreamController<String?>.broadcast();

  @override
  Future<void> initialize() async {
    developer.log(
      'NoopNotificationsService initialized (Firebase not available)',
      name: 'Notifications',
    );
  }

  @override
  Future<bool> requestPermission() async {
    developer.log(
      'Notification permission skipped (Firebase not available)',
      name: 'Notifications',
    );
    return false;
  }

  @override
  Future<String?> getToken() async {
    return null;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    developer.log(
      'Topic subscription skipped: $topic (Firebase not available)',
      name: 'Notifications',
    );
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    developer.log(
      'Topic unsubscription skipped: $topic (Firebase not available)',
      name: 'Notifications',
    );
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    developer.log(
      'Local notification skipped: $title (Firebase not available)',
      name: 'Notifications',
    );
  }

  @override
  Stream<String?> get onNotificationTap => _notificationTapController.stream;

  @override
  void dispose() {
    _notificationTapController.close();
  }
}
