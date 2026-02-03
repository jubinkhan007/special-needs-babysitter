import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';

// NOTE: To enable full CallKit functionality, run:
//   flutter pub get
// after adding flutter_callkit_incoming to pubspec.yaml
//
// Then uncomment the imports and implementations below.

// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_callkit_incoming/entities/entities.dart';

/// Service for handling call-related push notifications
///
/// FIX #4: Accepts Map<String, dynamic> directly, with wrapper for RemoteMessage
///
/// NOTE: This is a stub implementation. For full CallKit functionality,
/// install flutter_callkit_incoming and update this file.
class CallNotificationService {
  /// Handle incoming call from push payload data
  ///
  /// This is the primary method - accepts raw Map data
  static Future<void> handleIncomingCallPayload(Map<String, dynamic> data) async {
    if (data['type'] != 'incoming_call') return;

    final callId = data['callId'] as String?;
    final callType = data['callType'] as String?;
    final callerName = data['callerName'] as String?;
    final callerAvatar = data['callerAvatar'] as String?;

    if (callId == null || callerName == null) {
      developer.log('Invalid incoming call payload: missing callId or callerName', name: 'Notifications');
      return;
    }

    await showIncomingCallUI(
      callId: callId,
      callerName: callerName,
      callerAvatar: callerAvatar,
      isVideo: callType == 'video',
    );
  }

  /// Wrapper for RemoteMessage (convenience method)
  static Future<void> handleIncomingCallMessage(RemoteMessage message) async {
    await handleIncomingCallPayload(message.data);
  }

  /// Show CallKit-style incoming call UI
  ///
  /// TODO: Implement with flutter_callkit_incoming after running flutter pub get
  static Future<void> showIncomingCallUI({
    required String callId,
    required String callerName,
    String? callerAvatar,
    bool isVideo = false,
  }) async {
    developer.log(
      'showIncomingCallUI: callId=$callId, caller=$callerName, isVideo=$isVideo',
      name: 'Notifications',
    );

    // STUB: Log only until flutter_callkit_incoming is installed
    // When ready, uncomment and implement:
    /*
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Special Needs Sitters',
      avatar: callerAvatar,
      handle: callerName,
      type: isVideo ? 1 : 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
      ),
      duration: 45000,
      extra: <String, dynamic>{
        'callId': callId,
        'isVideo': isVideo,
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'ringtone_default',
        backgroundColor: '#1E88E5',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Calls',
        isShowFullLockedScreen: true,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    */

    developer.log('Showing incoming call UI for $callId (stub)', name: 'Notifications');
  }

  /// End specific call UI
  static Future<void> endCall(String callId) async {
    developer.log('Ending CallKit UI for $callId', name: 'Notifications');
    // await FlutterCallkitIncoming.endCall(callId);
  }

  /// End all active call UIs
  static Future<void> endAllCalls() async {
    developer.log('Ending all CallKit UIs', name: 'Notifications');
    // await FlutterCallkitIncoming.endAllCalls();
  }

  /// Get active calls
  static Future<List<dynamic>> getActiveCalls() async {
    // return await FlutterCallkitIncoming.activeCalls();
    return [];
  }

  /// Start an outgoing call (for UI purposes)
  static Future<void> startOutgoingCall({
    required String callId,
    required String calleeName,
    String? calleeAvatar,
    bool isVideo = false,
  }) async {
    developer.log('Starting outgoing call UI for $callId', name: 'Notifications');
    // Implement with flutter_callkit_incoming
  }

  /// Set call as connected (for UI purposes)
  static Future<void> setCallConnected(String callId) async {
    developer.log('Setting call $callId as connected', name: 'Notifications');
    // await FlutterCallkitIncoming.setCallConnected(callId);
  }
}
