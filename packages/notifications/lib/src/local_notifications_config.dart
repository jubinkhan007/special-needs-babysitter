import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:core/core.dart';

/// Configuration for local notifications
class LocalNotificationsConfig {
  LocalNotificationsConfig._();

  /// Initialize local notifications plugin
  static Future<void> initialize(
    FlutterLocalNotificationsPlugin plugin, {
    required void Function(String?) onNotificationTap,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap(response.payload);
      },
    );

    // Create Android notification channel
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _createAndroidChannel(plugin);
    }
  }

  static Future<void> _createAndroidChannel(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    const channel = AndroidNotificationChannel(
      Constants.notificationChannelId,
      Constants.notificationChannelName,
      description: Constants.notificationChannelDescription,
      importance: Importance.high,
    );

    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
