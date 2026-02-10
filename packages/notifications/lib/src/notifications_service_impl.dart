import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:core/core.dart';

import 'notifications_service.dart';
import 'local_notifications_config.dart';

/// Firebase + Local Notifications implementation
class NotificationsServiceImpl implements NotificationsService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final _notificationTapController = StreamController<String?>.broadcast();

  /// Dedup: track recently shown notification fingerprints to prevent
  /// duplicate notifications when the backend sends multiple FCM messages
  /// for the same chat message.
  final Map<String, DateTime> _recentNotificationFingerprints = {};
  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  NotificationsServiceImpl({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    // Initialize local notifications
    await LocalNotificationsConfig.initialize(
      _localNotifications,
      onNotificationTap: _handleNotificationTap,
    );

    // Tell iOS to show notification banners even when app is in foreground
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
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
      final token = await _getTokenWithRetries();
      final tokenState =
          token == null || token.isEmpty ? 'empty' : 'len=${token.length}';
      developer.log('getToken completed with $tokenState', name: 'FCM_FLOW');
      print('[FCM_FLOW] getToken completed with $tokenState');
      return token;
    } catch (e, st) {
      if (e is FirebaseException) {
        developer.log(
          'Failed to get FCM token: '
          'plugin=${e.plugin}, code=${e.code}, message=${e.message}',
          name: 'Notifications',
          stackTrace: st,
        );
      } else {
        developer.log(
          'Failed to get FCM token: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
      return null;
    }
  }

  @override
  Future<String?> forceRefreshToken() async {
    try {
      if (_isIOS) {
        // On iOS, immediate delete+get can intermittently fail with
        // firebase_messaging unknown errors while token state is converging.
        // Prefer a retry-based fresh fetch without delete.
        developer.log(
          'iOS token refresh requested; skipping deleteToken and retrying getToken',
          name: 'Notifications',
        );
        // On iOS, first wait for APNS token to stabilize before requesting FCM
        await _waitForAPNSToken(
          maxAttempts: 5,
          delay: const Duration(milliseconds: 400),
        );
      } else {
        await _messaging.deleteToken();
        developer.log('Deleted existing FCM token, requesting new token',
            name: 'Notifications');
      }
      final token = await _getTokenWithRetries(
        attempts: _isIOS ? 5 : 3,
        initialDelay: const Duration(milliseconds: 600),
      );
      final tokenState =
          token == null || token.isEmpty ? 'empty' : 'len=${token.length}';
      developer.log(
        'forceRefreshToken completed with $tokenState',
        name: 'FCM_FLOW',
      );
      print('[FCM_FLOW] forceRefreshToken completed with $tokenState');
      return token;
    } on FirebaseException catch (e, st) {
      developer.log(
        'Failed to force refresh FCM token: '
        'plugin=${e.plugin}, code=${e.code}, message=${e.message}',
        name: 'Notifications',
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      developer.log(
        'Failed to force refresh FCM token: $e',
        name: 'Notifications',
        stackTrace: st,
      );
      return null;
    }
  }

  /// Wait for APNS token to be available on iOS.
  /// Returns true if token is available, false if timed out.
  Future<bool> _waitForAPNSToken({
    required int maxAttempts,
    required Duration delay,
  }) async {
    var currentDelay = delay;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          developer.log(
            'APNS token ready after $attempt attempts',
            name: 'Notifications',
          );
          // Give extra time for FCM token negotiation after APNS is ready
          await Future<void>.delayed(const Duration(milliseconds: 300));
          return true;
        }
      } catch (e) {
        developer.log(
          'APNS token check attempt $attempt/$maxAttempts failed: $e',
          name: 'Notifications',
        );
      }
      if (attempt < maxAttempts) {
        await Future<void>.delayed(currentDelay);
        currentDelay += currentDelay;
      }
    }
    developer.log(
      'APNS token not available after $maxAttempts attempts',
      name: 'Notifications',
    );
    return false;
  }

  Future<String?> _getTokenWithRetries({
    int attempts = 3,
    Duration initialDelay = const Duration(milliseconds: 400),
  }) async {
    var delay = initialDelay;
    FirebaseException? lastFirebaseException;
    Object? lastError;
    StackTrace? lastStack;

    for (var attempt = 1; attempt <= attempts; attempt++) {
      try {
        // On iOS, we need to be more patient - wait for both APNS and FCM
        // token propagation to complete.
        if (_isIOS) {
          // First, ensure APNS token is available
          var apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null || apnsToken.isEmpty) {
            developer.log(
              'iOS APNS token not ready on getToken attempt $attempt/$attempts',
              name: 'Notifications',
            );
            if (attempt < attempts) {
              await Future<void>.delayed(delay);
              delay += delay;
            }
            continue;
          }

          // APNS token exists, but FCM token may still be negotiating with
          // Firebase servers. Give it a brief moment to complete.
          if (attempt == 1) {
            await Future<void>.delayed(const Duration(milliseconds: 500));
          }
        }

        final token = await _messaging.getToken();
        if (token != null && token.isNotEmpty) {
          if (attempt > 1) {
            developer.log(
              'FCM token succeeded on retry attempt $attempt/$attempts',
              name: 'Notifications',
            );
          }
          return token;
        }

        developer.log(
          'FCM token empty on attempt $attempt/$attempts',
          name: 'Notifications',
        );
      } on FirebaseException catch (e, st) {
        lastError = e;
        lastStack = st;
        lastFirebaseException = e;
        developer.log(
          'getToken attempt $attempt/$attempts failed: '
          'plugin=${e.plugin}, code=${e.code}, message=${e.message}',
          name: 'Notifications',
          stackTrace: st,
        );

        // On iOS, "unknown" errors during token retrieval are often transient
        // and resolve with a retry after a longer delay.
        if (_isIOS && e.code == 'unknown') {
          developer.log(
            'iOS transient error detected; will retry with longer delay',
            name: 'Notifications',
          );
        }
      } catch (e, st) {
        lastError = e;
        lastStack = st;
        developer.log(
          'getToken attempt $attempt/$attempts failed: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }

      if (attempt < attempts) {
        await Future<void>.delayed(delay);
        delay += delay;
      }
    }

    if (lastFirebaseException != null) {
      developer.log(
        'FCM token retries exhausted: '
        'plugin=${lastFirebaseException.plugin}, '
        'code=${lastFirebaseException.code}, '
        'message=${lastFirebaseException.message}',
        name: 'Notifications',
        stackTrace: lastStack,
      );
    } else if (lastError != null) {
      developer.log(
        'FCM token retries exhausted: $lastError',
        name: 'Notifications',
        stackTrace: lastStack,
      );
    }
    return null;
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

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  void _handleForegroundMessage(RemoteMessage message) {
    developer.log(
      'Got foreground message: ${message.notification?.title ?? message.data.toString()}',
      name: 'Notifications',
    );

    // Skip showing generic notifications for call-signaling payloads.
    if (_isCallSignalingMessage(message)) {
      final type = message.data['type']?.toString().toLowerCase() ?? '';
      developer.log(
          'Skipping notification for call-related payload type: $type',
          name: 'Notifications');
      return;
    }

    final notification = message.notification;
    final title = notification?.title ?? _extractTitle(message);
    final body = notification?.body ?? _extractBody(message);

    // Dedup: build a fingerprint from title+body to detect duplicate FCM
    // messages sent by the backend for the same chat message.
    final fingerprint = '$title|$body';
    _cleanOldFingerprints();
    if (_recentNotificationFingerprints.containsKey(fingerprint)) {
      developer.log(
        'Skipping duplicate notification: $fingerprint',
        name: 'Notifications',
      );
      return;
    }
    _recentNotificationFingerprints[fingerprint] = DateTime.now();

    if (title.isNotEmpty || body.isNotEmpty) {
      showNotification(
        title: title.isNotEmpty ? title : 'New Notification',
        body: body,
        payload: _buildTapPayload(message),
      );
    }
  }

  /// Remove fingerprints older than 5 seconds to prevent unbounded growth.
  void _cleanOldFingerprints() {
    final cutoff = DateTime.now().subtract(const Duration(seconds: 5));
    _recentNotificationFingerprints.removeWhere((_, ts) => ts.isBefore(cutoff));
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log(
      'Notification opened app: ${message.notification?.title}',
      name: 'Notifications',
    );
    _notificationTapController.add(_buildTapPayload(message));
  }

  void _handleNotificationTap(String? payload) {
    _notificationTapController.add(payload);
  }

  String _extractTitle(RemoteMessage message) {
    final data = message.data;
    return _firstNonEmpty(
          [
            message.notification?.title,
            data['title']?.toString(),
            data['senderName']?.toString(),
            data['sender_name']?.toString(),
            data['fromName']?.toString(),
            data['name']?.toString(),
          ],
        ) ??
        '';
  }

  String _extractBody(RemoteMessage message) {
    final data = message.data;
    String? body = _firstNonEmpty(
      [
        message.notification?.body,
        data['body']?.toString(),
        data['message']?.toString(),
        data['text']?.toString(),
        data['textContent']?.toString(),
        data['content']?.toString(),
      ],
    );

    // Skip if body is a call_invite JSON payload
    if (body != null && _isCallInviteJson(body)) {
      return '';
    }

    return body ?? '';
  }

  bool _isCallInviteJson(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('{')) return false;
    return trimmed.contains('"type"') && trimmed.contains('call_invite');
  }

  bool _isCallSignalingMessage(RemoteMessage message) {
    final type = message.data['type']?.toString().toLowerCase() ?? '';
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

  String? _firstNonEmpty(List<String?> candidates) {
    for (final candidate in candidates) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }

  @override
  Future<void> runDiagnostics() async {
    developer.log('=== FCM DIAGNOSTICS START ===', name: 'FCM_DIAG');

    // 0. Firebase app preflight
    try {
      final apps = Firebase.apps;
      developer.log(
        '[0/6] Firebase apps count: ${apps.length}',
        name: 'FCM_DIAG',
      );
      if (apps.isEmpty) {
        developer.log(
          '  >> PROBLEM: Firebase.initializeApp() has not completed.',
          name: 'FCM_DIAG',
        );
      } else {
        final app = Firebase.app();
        final options = app.options;
        final apiKeySuffix = options.apiKey.length >= 6
            ? options.apiKey.substring(options.apiKey.length - 6)
            : options.apiKey;
        developer.log(
          '[0/6] Firebase app="${app.name}" '
          'projectId="${options.projectId}" '
          'appId="${options.appId}" '
          'senderId="${options.messagingSenderId}" '
          'apiKey=*${apiKeySuffix}',
          name: 'FCM_DIAG',
        );
      }
      developer.log(
        '[0/6] Platform: ${defaultTargetPlatform.name}, kIsWeb=$kIsWeb',
        name: 'FCM_DIAG',
      );
    } catch (e, st) {
      _logDiagException(
          step: '[0/6] Firebase preflight FAILED', error: e, stack: st);
    }

    // 1. Check notification permission status
    try {
      final settings = await _messaging.getNotificationSettings();
      developer.log(
        '[1/6] Permission status: ${settings.authorizationStatus}',
        name: 'FCM_DIAG',
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        developer.log(
          '  >> PROBLEM: Notifications not authorized. '
          'User must grant permission in device Settings.',
          name: 'FCM_DIAG',
        );
      }
    } catch (e, st) {
      _logDiagException(
          step: '[1/6] Permission check FAILED', error: e, stack: st);
    }

    // 2. Check APNS token (iOS only — null on Android)
    try {
      final apnsToken = await _messaging.getAPNSToken();
      developer.log(
        '[2/6] APNS token: ${apnsToken != null ? "${apnsToken.length} bytes" : "null (expected on Android)"}',
        name: 'FCM_DIAG',
      );
      if (apnsToken == null) {
        developer.log(
          '  >> On iOS this means APNS registration failed. '
          'Check: real device (not simulator), Push Notification capability in Xcode, '
          'valid provisioning profile, Runner.entitlements present.',
          name: 'FCM_DIAG',
        );
      }
    } catch (e, st) {
      _logDiagException(
          step: '[2/6] APNS token check FAILED', error: e, stack: st);
    }

    // 3. Check FCM token (use retry logic for more accurate diagnostics)
    try {
      final fcmToken = await _getTokenWithRetries(
        attempts: _isIOS ? 5 : 3,
        initialDelay: const Duration(milliseconds: 400),
      );
      if (fcmToken != null && fcmToken.isNotEmpty) {
        developer.log(
          '[3/6] FCM token: ${fcmToken.substring(0, 20)}...${fcmToken.substring(fcmToken.length - 10)}',
          name: 'FCM_DIAG',
        );
      } else {
        developer.log(
          '[3/6] FCM token: NULL or EMPTY (after retries)',
          name: 'FCM_DIAG',
        );
        developer.log(
          '  >> PROBLEM: No FCM token. On iOS, APNS token must be available first '
          'and there may be a delay for FCM token negotiation. '
          'On Android, check google-services.json is correct and network is available.',
          name: 'FCM_DIAG',
        );
      }
    } catch (e, st) {
      _logDiagException(
          step: '[3/6] FCM token retrieval FAILED', error: e, stack: st);
      if (e is FirebaseException &&
          (e.message?.contains('AUTHENTICATION_FAILED') ?? false)) {
        developer.log(
          '  >> AUTHENTICATION_FAILED checklist (Android): '
          '1) Use a real device or Google Play emulator signed into Play Store, '
          '2) Add BOTH SHA-1 and SHA-256 for app package in Firebase Console, '
          '3) Download fresh google-services.json into android/app/, '
          '4) Ensure Firebase Installations API is enabled, '
          '5) Verify API key restrictions allow this app+SHA, '
          '6) Reinstall app after flutter clean.',
          name: 'FCM_DIAG',
        );
      } else if (e is FirebaseException && e.code == 'unknown') {
        developer.log(
          '  >> UNKNOWN_ERROR checklist (iOS): '
          '1) Real device required (not simulator), '
          '2) Push Notifications capability enabled in Xcode, '
          '3) Background Modes -> Remote Notifications enabled, '
          '4) Valid APNs Auth Key (.p8) configured in Firebase Console, '
          '5) Valid provisioning profile with push enabled, '
          '6) Delete app and reinstall after flutter clean.',
          name: 'FCM_DIAG',
        );
      }
    }

    // 4. Check auto-init
    try {
      final autoInit = _messaging.isAutoInitEnabled;
      developer.log(
        '[4/6] Auto-init enabled: $autoInit',
        name: 'FCM_DIAG',
      );
    } catch (e, st) {
      _logDiagException(
          step: '[4/6] Auto-init check FAILED', error: e, stack: st);
    }

    // 5. Check current app state tokens from plugin cache
    try {
      final apnsToken = await _messaging.getAPNSToken();
      developer.log(
        '[5/6] Token snapshot -> APNS:${apnsToken == null ? "none" : "present"}',
        name: 'FCM_DIAG',
      );
    } catch (e, st) {
      _logDiagException(
          step: '[5/6] Token snapshot FAILED', error: e, stack: st);
    }

    // 6. Fire a test local notification to verify local notifications work
    try {
      await showNotification(
        title: 'FCM Diagnostics',
        body: 'If you see this, local notifications are working.',
      );
      developer.log(
        '[6/6] Test local notification fired. If you do NOT see it, '
        'check: notification channel settings, Do Not Disturb, '
        'app notification settings in device Settings.',
        name: 'FCM_DIAG',
      );
    } catch (e, st) {
      _logDiagException(
          step: '[6/6] Test local notification FAILED', error: e, stack: st);
    }

    developer.log('=== FCM DIAGNOSTICS END ===', name: 'FCM_DIAG');
  }

  void _logDiagException({
    required String step,
    required Object error,
    required StackTrace stack,
  }) {
    if (error is FirebaseException) {
      developer.log(
        '$step: plugin=${error.plugin}, code=${error.code}, message=${error.message}',
        name: 'FCM_DIAG',
        stackTrace: stack,
      );
      return;
    }
    developer.log(
      '$step: $error',
      name: 'FCM_DIAG',
      stackTrace: stack,
    );
  }

  @override
  void dispose() {
    _notificationTapController.close();
  }
}
