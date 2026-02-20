import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:notifications/notifications.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'src/features/calls/services/call_notification_service.dart';
import 'src/services/paypal_deep_link_service.dart';

final FlutterLocalNotificationsPlugin _backgroundLocalNotifications =
    FlutterLocalNotificationsPlugin();
bool _backgroundNotificationsInitialized = false;

/// Top-level background message handler (required by Firebase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background handling
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  developer.log(
    'Background message: ${message.notification?.title}',
    name: 'Notifications',
  );

  // Handle incoming call notifications in background
  final type = (message.data['type'] ?? '').toString().toLowerCase();
  if (type == 'incoming_call' || type == 'call_invite') {
    // Extract call details from payload (handle both type names)
    final callId = message.data['callId'] ?? message.data['call_id'];
    final callType =
        message.data['callType'] ?? message.data['call_type'] ?? 'audio';
    final callerName = message.data['callerName'] ??
        message.data['caller_name'] ??
        message.data['senderName'] ??
        message.data['sender_name'] ??
        'Unknown';
    final callerUserId = message.data['callerUserId'] ??
        message.data['caller_user_id'] ??
        message.data['senderUserId'] ??
        message.data['sender_user_id'] ??
        '';
    final callerAvatar =
        message.data['callerAvatar'] ?? message.data['caller_avatar'];

    if (callId != null) {
      await CallNotificationService.showIncomingCallUI(
        callId: callId.toString(),
        callerName: callerName.toString(),
        callerUserId: callerUserId.toString(),
        callerAvatar: callerAvatar?.toString(),
        isVideo: callType.toString().toLowerCase() == 'video',
      );
    }
    return;
  }

  if (type == 'call_status' || type == 'call_event') {
    final status = (message.data['status'] ?? message.data['event'] ?? '')
        .toString()
        .toLowerCase();
    final callId =
        (message.data['callId'] ?? message.data['call_id'])?.toString();
    if (callId != null &&
        (status == 'accepted' ||
            status == 'ended' ||
            status == 'declined' ||
            status == 'missed')) {
      await CallNotificationService.endCall(callId);
    }
    return;
  }

  // For notification-type messages (with a `notification` payload), Android
  // auto-displays them in the system tray. Showing a local notification here
  // would create a duplicate. Only show a local notification for data-only
  // messages where Android does NOT auto-display.
  if (message.notification != null) {
    developer.log(
      'Background handler: skipping local notification (FCM auto-displays notification-type messages)',
      name: 'Notifications',
    );
    return;
  }

  // Safety net: never treat call-related data-only payloads as chat notifications.
  if (_isCallSignalingPayload(message)) {
    return;
  }

  final title = _firstNonEmpty([
    message.data['title']?.toString(),
    message.data['senderName']?.toString(),
    message.data['sender_name']?.toString(),
  ]);
  final body = _firstNonEmpty([
    message.data['body']?.toString(),
    message.data['message']?.toString(),
    message.data['text']?.toString(),
    message.data['textContent']?.toString(),
  ]);

  if ((title ?? '').isNotEmpty || (body ?? '').isNotEmpty) {
    final payload = _buildTapPayload(message);
    await _showBackgroundLocalNotification(
      title: title ?? 'Notification',
      body: body ?? '',
      payload: payload,
    );
  }
}

Future<void> _showBackgroundLocalNotification({
  required String title,
  required String body,
  String? payload,
}) async {
  try {
    if (!_backgroundNotificationsInitialized) {
      await _backgroundLocalNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );

      const channel = AndroidNotificationChannel(
        Constants.notificationChannelId,
        Constants.notificationChannelName,
        description: Constants.notificationChannelDescription,
        importance: Importance.high,
      );

      await _backgroundLocalNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _backgroundNotificationsInitialized = true;
    }

    await _backgroundLocalNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          Constants.notificationChannelId,
          Constants.notificationChannelName,
          channelDescription: Constants.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  } catch (e, st) {
    developer.log(
      'Background local notification failed: $e',
      name: 'Notifications',
      stackTrace: st,
    );
  }
}

String? _buildTapPayload(RemoteMessage message) {
  final data = message.data;

  final route = data['route']?.toString();
  if (route != null && route.trim().isNotEmpty) {
    return route.trim();
  }

  final type = data['type']?.toString().trim().toLowerCase();
  if (type == 'new_message' || type == 'message' || type == 'chat_message') {
    final senderUserId = _firstNonEmpty([
      data['senderUserId']?.toString(),
      data['sender_user_id']?.toString(),
      data['otherUserId']?.toString(),
      data['other_user_id']?.toString(),
    ]);
    if (senderUserId != null) {
      return 'chat:$senderUserId';
    }
  }

  return null;
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return null;
}

bool _isCallSignalingPayload(RemoteMessage message) {
  final type = (message.data['type'] ?? '').toString().toLowerCase();
  if (type == 'incoming_call' ||
      type == 'call_invite' ||
      type == 'call_status' ||
      type == 'call_event' ||
      type.startsWith('call_')) {
    return true;
  }

  final bodyCandidates = <String?>[
    message.notification?.body,
    message.data['body']?.toString(),
    message.data['message']?.toString(),
    message.data['text']?.toString(),
    message.data['textContent']?.toString(),
    message.data['content']?.toString(),
  ];

  for (final body in bodyCandidates) {
    if (body == null) continue;
    final normalized = body.toLowerCase().replaceAll(' ', '');
    if (!normalized.startsWith('{')) continue;
    if (normalized.contains('"type":"call_invite"') ||
        normalized.contains('"type":"incoming_call"') ||
        normalized.contains('"type":"call_status"') ||
        normalized.contains('"type":"call_event"') ||
        normalized.contains('"callid"')) {
      return true;
    }
  }

  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await EnvConfig.tryLoad();

  // Initialize Stripe
  Stripe.publishableKey =
      'pk_test_51SpPCQA94FXRonexZprCttmNtDC5z91d57n5MVW1r8TjGPApriYe9FTiZXbYOx9TVytNLchLwsAUvfJvuXzDBzmf00LJxEXg8h';
  Stripe.merchantIdentifier = 'merchant.com.specialneedssitters';
  await Stripe.instance.applySettings();

  // Initialize PayPal deep link service
  await PaypalDeepLinkService.instance.init();

  // Initialize Firebase with try/catch for missing config
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseReady = true;
    developer.log('Firebase initialized successfully', name: 'App');
  } catch (e) {
    developer.log(
      'Firebase initialization failed (config may be missing): $e',
      name: 'App',
    );
    // Continue without Firebase - app will use no-op notifications
  }

  runApp(
    ProviderScope(
      overrides: [
        // Set Firebase ready state based on initialization result
        firebaseReadyProvider.overrideWith((ref) => firebaseReady),
      ],
      child: const BabysitterApp(),
    ),
  );
}
