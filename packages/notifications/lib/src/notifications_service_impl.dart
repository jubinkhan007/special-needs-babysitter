import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:core/core.dart';

import 'notifications_service.dart';
import 'local_notifications_config.dart';

/// Firebase + Local Notifications implementation
class NotificationsServiceImpl implements NotificationsService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final _notificationTapController = StreamController<String?>.broadcast();

  NotificationsServiceImpl({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    // Initialize local notifications
    await LocalNotificationsConfig.initialize(
      _localNotifications,
      onNotificationTap: _handleNotificationTap,
    );

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Set up notification tap handler when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    developer.log('NotificationsService initialized', name: 'Notifications');
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      developer.log('Failed to get FCM token: $e', name: 'Notifications');
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    developer.log('Subscribed to topic: $topic', name: 'Notifications');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    developer.log('Unsubscribed from topic: $topic', name: 'Notifications');
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          Constants.notificationChannelId,
          Constants.notificationChannelName,
          channelDescription: Constants.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  @override
  Stream<String?> get onNotificationTap => _notificationTapController.stream;

  void _handleForegroundMessage(RemoteMessage message) {
    developer.log(
      'Got foreground message: ${message.notification?.title}',
      name: 'Notifications',
    );

    // Show local notification
    final notification = message.notification;
    if (notification != null) {
      showNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: message.data['route'] as String?,
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log(
      'Notification opened app: ${message.notification?.title}',
      name: 'Notifications',
    );
    _notificationTapController.add(message.data['route'] as String?);
  }

  void _handleNotificationTap(String? payload) {
    _notificationTapController.add(payload);
  }

  @override
  void dispose() {
    _notificationTapController.close();
  }
}
