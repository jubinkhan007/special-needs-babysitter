import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for handling call-related push notifications
///
/// FIX #4: Accepts Map<String, dynamic> directly, with wrapper for RemoteMessage
///
/// NOTE: This is a stub implementation. For full CallKit functionality,
/// install flutter_callkit_incoming and update this file.
class CallNotificationService {
  static const String _callChannelId = 'incoming_calls_channel';
  static const String _callChannelName = 'Incoming Calls';
  static const String _callChannelDescription = 'Incoming call alerts';
  static const String _actionAccept = 'accept_call';
  static const String _actionDecline = 'decline_call';

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final StreamController<CallNotificationActionEvent> _actionController =
      StreamController<CallNotificationActionEvent>.broadcast();

  static bool _localNotificationsInitialized = false;
  static bool _launchDetailsChecked = false;
  static final Set<String> _processedActionKeys = <String>{};

  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Fallback handler for notification taps that are NOT call-related.
  /// Set this from the app layer so non-call notification taps are forwarded
  /// to the main notification service.
  static void Function(String?)? fallbackNotificationTapHandler;

  static Stream<CallNotificationActionEvent> get onCallAction =>
      _actionController.stream;

  /// Ensure notification action callbacks are wired on the main isolate.
  static Future<void> initializeActionHandling() async {
    await _ensureLocalNotificationsInitialized();
  }

  /// Handle incoming call from push payload data
  ///
  /// This is the primary method - accepts raw Map data
  static Future<void> handleIncomingCallPayload(
      Map<String, dynamic> data) async {
    final type = data['type']?.toString();
    if (type != 'incoming_call' && type != 'call_invite') return;

    final callId = data['callId'] as String?;
    final callType = data['callType'] as String?;
    final callerName = (data['callerName'] ?? data['senderName']) as String?;
    var callerUserId =
        (data['callerUserId'] ?? data['senderUserId']) as String?;
    final callerAvatar = data['callerAvatar'] as String?;

    if ((callerUserId == null || callerUserId.isEmpty) &&
        callId != null &&
        callId.isNotEmpty) {
      callerUserId = '_unknown_$callId';
    }

    if (callId == null || callerName == null || callerUserId == null) {
      developer.log(
          'Invalid incoming call payload: missing callId/callerName/callerUserId',
          name: 'Notifications');
      return;
    }

    await showIncomingCallUI(
      callId: callId,
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
      isVideo: callType == 'video',
    );
  }

  /// Wrapper for RemoteMessage (convenience method)
  static Future<void> handleIncomingCallMessage(RemoteMessage message) async {
    await handleIncomingCallPayload(message.data);
  }

  /// Show incoming call UI.
  /// iOS: native CallKit via flutter_callkit_incoming.
  /// Android: existing high-priority full-screen notification fallback.
  static Future<void> showIncomingCallUI({
    required String callId,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
    bool isVideo = false,
  }) async {
    developer.log(
      'showIncomingCallUI: callId=$callId, caller=$callerName, isVideo=$isVideo',
      name: 'Notifications',
    );

    if (_isIOS) {
      try {
        await _showIncomingCallKitUI(
          callId: callId,
          callerName: callerName,
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
          isVideo: isVideo,
        );
        return;
      } catch (e, st) {
        developer.log(
          'CallKit incoming UI failed, falling back to local notification: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
    }

    await _showFallbackIncomingCallNotification(
      callId: callId,
      callerName: callerName,
      callerUserId: callerUserId,
      isVideo: isVideo,
    );
  }

  static Future<void> _showIncomingCallKitUI({
    required String callId,
    required String callerName,
    required String callerUserId,
    required String? callerAvatar,
    required bool isVideo,
  }) async {
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Special Needs Sitters',
      avatar: callerAvatar,
      handle: callerName,
      type: isVideo ? 1 : 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 45000,
      extra: <String, dynamic>{
        'callId': callId,
        'callerName': callerName,
        'callerUserId': callerUserId,
        'callerAvatar': callerAvatar ?? '',
        'isVideo': isVideo,
      },
      ios: IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: isVideo,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    developer.log('Showing iOS CallKit incoming UI for $callId',
        name: 'Notifications');
  }

  /// End specific call UI
  static Future<void> endCall(String callId) async {
    developer.log('Ending CallKit UI for $callId', name: 'Notifications');
    if (_isIOS) {
      try {
        await FlutterCallkitIncoming.endCall(callId);
      } catch (e, st) {
        developer.log(
          'Failed to end iOS CallKit call for $callId: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
    }
    try {
      await _ensureLocalNotificationsInitialized();
      await _localNotifications.cancel(callId.hashCode);
    } catch (e, st) {
      developer.log(
        'Failed to cancel call notification for $callId: $e',
        name: 'Notifications',
        stackTrace: st,
      );
    }
    // await FlutterCallkitIncoming.endCall(callId);
  }

  /// End all active call UIs
  static Future<void> endAllCalls() async {
    developer.log('Ending all CallKit UIs', name: 'Notifications');
    if (_isIOS) {
      try {
        await FlutterCallkitIncoming.endAllCalls();
      } catch (e, st) {
        developer.log(
          'Failed to end all iOS CallKit calls: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
    }
    try {
      await _ensureLocalNotificationsInitialized();
      await _localNotifications.cancelAll();
    } catch (e, st) {
      developer.log(
        'Failed to cancel all call notifications: $e',
        name: 'Notifications',
        stackTrace: st,
      );
    }
    // await FlutterCallkitIncoming.endAllCalls();
  }

  /// Get active calls
  static Future<List<dynamic>> getActiveCalls() async {
    if (_isIOS) {
      try {
        final calls = await FlutterCallkitIncoming.activeCalls();
        if (calls is List<dynamic>) return calls;
        if (calls == null) return <dynamic>[];
        return <dynamic>[calls];
      } catch (e, st) {
        developer.log(
          'Failed to fetch active iOS CallKit calls: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
    }
    return [];
  }

  /// Start an outgoing call (for UI purposes)
  static Future<void> startOutgoingCall({
    required String callId,
    required String calleeName,
    String? calleeAvatar,
    bool isVideo = false,
  }) async {
    developer.log('Starting outgoing call UI for $callId',
        name: 'Notifications');
    // Implement with flutter_callkit_incoming
  }

  /// Set call as connected (for UI purposes)
  static Future<void> setCallConnected(String callId) async {
    developer.log('Setting call $callId as connected', name: 'Notifications');
    if (_isIOS) {
      try {
        await FlutterCallkitIncoming.setCallConnected(callId);
      } catch (e, st) {
        developer.log(
          'Failed to set iOS CallKit call connected for $callId: $e',
          name: 'Notifications',
          stackTrace: st,
        );
      }
    }
  }

  static Future<void> _showFallbackIncomingCallNotification({
    required String callId,
    required String callerName,
    required String callerUserId,
    required bool isVideo,
  }) async {
    try {
      await _ensureLocalNotificationsInitialized();
      final payload = _encodePayload(
        callId: callId,
        callerName: callerName,
        callerUserId: callerUserId,
        isVideo: isVideo,
      );

      final callKind = isVideo ? 'Video' : 'Audio';
      await _localNotifications.show(
        callId.hashCode,
        'Incoming $callKind Call',
        '$callerName is calling you',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _callChannelId,
            _callChannelName,
            channelDescription: _callChannelDescription,
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.call,
            fullScreenIntent: true,
            ongoing: true,
            autoCancel: false,
            visibility: NotificationVisibility.public,
            timeoutAfter: 45000,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                _actionDecline,
                'Decline',
                // Launch app for reliable handling when device is locked or app is killed.
                // Without this, background action callbacks can be dropped on some devices.
                showsUserInterface: true,
                cancelNotification: true,
              ),
              AndroidNotificationAction(
                _actionAccept,
                'Accept',
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ],
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
        'Failed to show fallback incoming call notification: $e',
        name: 'Notifications',
        stackTrace: st,
      );
    }
  }

  static Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized) return;

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          callNotificationResponseBackgroundHandler,
    );

    const channel = AndroidNotificationChannel(
      _callChannelId,
      _callChannelName,
      description: _callChannelDescription,
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _localNotificationsInitialized = true;
    await _dispatchLaunchNotificationActionIfNeeded();
  }

  static Future<void> _dispatchLaunchNotificationActionIfNeeded() async {
    if (_launchDetailsChecked) return;
    _launchDetailsChecked = true;

    try {
      final launchDetails =
          await _localNotifications.getNotificationAppLaunchDetails();
      if (launchDetails == null || !launchDetails.didNotificationLaunchApp) {
        return;
      }
      final response = launchDetails.notificationResponse;
      if (response == null) {
        developer.log(
          '[CALL_ACTION] launchDetails had no notificationResponse',
          name: 'Notifications',
        );
        return;
      }
      developer.log(
        '[CALL_ACTION] launchDetails recovered action=${response.actionId ?? 'open'} payload=${response.payload}',
        name: 'Notifications',
      );
      debugPrint(
        '[CALL_ACTION] launchDetails recovered action=${response.actionId ?? 'open'} payload=${response.payload}',
      );
      await _handleNotificationResponse(response);
    } catch (e, st) {
      developer.log(
        'Failed to process launch notification action: $e',
        name: 'Notifications',
        stackTrace: st,
      );
    }
  }

  static Future<void> _handleNotificationResponse(
      NotificationResponse response) async {
    developer.log(
      '[CALL_ACTION] notification response received action=${response.actionId ?? 'open'} payload=${response.payload}',
      name: 'Notifications',
    );
    debugPrint(
      '[CALL_ACTION] notification response received action=${response.actionId ?? 'open'} payload=${response.payload}',
    );
    final payload = _decodePayload(response.payload);
    if (payload == null) {
      // Not a call notification — forward to main notification handler
      if (fallbackNotificationTapHandler != null) {
        developer.log(
          '[CALL_ACTION] forwarding non-call notification tap to fallback handler',
          name: 'Notifications',
        );
        fallbackNotificationTapHandler!(response.payload);
      } else {
        developer.log(
          'Ignoring notification response: not a call payload and no fallback handler',
          name: 'Notifications',
        );
      }
      return;
    }

    final actionId = response.actionId;
    final actionKey = '${payload.callId}:${actionId ?? 'open'}';
    if (!_processedActionKeys.add(actionKey)) {
      developer.log(
        'Ignoring duplicate call notification action: $actionKey',
        name: 'Notifications',
      );
      return;
    }

    if (actionId == _actionAccept) {
      developer.log(
        '[CALL_ACTION] emitting accept event callId=${payload.callId}',
        name: 'Notifications',
      );
      await endCall(payload.callId);
      _actionController.add(
        CallNotificationActionEvent.accept(
          callId: payload.callId,
          callerName: payload.callerName,
          callerUserId: payload.callerUserId,
          isVideo: payload.isVideo,
        ),
      );
      return;
    }
    if (actionId == _actionDecline) {
      developer.log(
        '[CALL_ACTION] emitting decline event callId=${payload.callId}',
        name: 'Notifications',
      );
      await endCall(payload.callId);
      _actionController.add(
        CallNotificationActionEvent.decline(
          callId: payload.callId,
          callerName: payload.callerName,
          callerUserId: payload.callerUserId,
          isVideo: payload.isVideo,
        ),
      );
      return;
    }

    await endCall(payload.callId);
    developer.log(
      '[CALL_ACTION] emitting open event callId=${payload.callId}',
      name: 'Notifications',
    );
    _actionController.add(
      CallNotificationActionEvent.open(
        callId: payload.callId,
        callerName: payload.callerName,
        callerUserId: payload.callerUserId,
        isVideo: payload.isVideo,
      ),
    );
  }

  static String _encodePayload({
    required String callId,
    required String callerName,
    required String callerUserId,
    required bool isVideo,
  }) {
    return jsonEncode({
      'callId': callId,
      'callerName': callerName,
      'callerUserId': callerUserId,
      'isVideo': isVideo,
    });
  }

  static _CallPayload? _decodePayload(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        // Not a JSON object — not a call payload
        return null;
      }
      final callId = decoded['callId']?.toString() ?? '';
      if (callId.isEmpty) {
        // No callId field — not a call payload
        return null;
      }
      return _CallPayload(
        callId: callId,
        callerName: decoded['callerName']?.toString() ?? 'Caller',
        callerUserId: decoded['callerUserId']?.toString() ?? '',
        isVideo: decoded['isVideo'] == true,
      );
    } catch (_) {
      // JSON parse failed — not a call payload
      return null;
    }
  }
}

@pragma('vm:entry-point')
void callNotificationResponseBackgroundHandler(NotificationResponse response) {
  unawaited(CallNotificationService._handleNotificationResponse(response));
}

enum CallNotificationActionType { open, accept, decline }

class CallNotificationActionEvent {
  final CallNotificationActionType type;
  final String callId;
  final String callerName;
  final String callerUserId;
  final bool isVideo;

  const CallNotificationActionEvent._({
    required this.type,
    required this.callId,
    required this.callerName,
    required this.callerUserId,
    required this.isVideo,
  });

  const CallNotificationActionEvent.open({
    required String callId,
    required String callerName,
    required String callerUserId,
    required bool isVideo,
  }) : this._(
          type: CallNotificationActionType.open,
          callId: callId,
          callerName: callerName,
          callerUserId: callerUserId,
          isVideo: isVideo,
        );

  const CallNotificationActionEvent.accept({
    required String callId,
    required String callerName,
    required String callerUserId,
    required bool isVideo,
  }) : this._(
          type: CallNotificationActionType.accept,
          callId: callId,
          callerName: callerName,
          callerUserId: callerUserId,
          isVideo: isVideo,
        );

  const CallNotificationActionEvent.decline({
    required String callId,
    required String callerName,
    required String callerUserId,
    required bool isVideo,
  }) : this._(
          type: CallNotificationActionType.decline,
          callId: callId,
          callerName: callerName,
          callerUserId: callerUserId,
          isVideo: isVideo,
        );
}

class _CallPayload {
  final String callId;
  final String callerName;
  final String callerUserId;
  final bool isVideo;

  const _CallPayload({
    required this.callId,
    required this.callerName,
    required this.callerUserId,
    required this.isVideo,
  });
}
