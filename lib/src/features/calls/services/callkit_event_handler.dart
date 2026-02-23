import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

/// Represents a CallKit action
sealed class CallKitAction {
  final String callId;
  const CallKitAction(this.callId);
}

class CallKitAccepted extends CallKitAction {
  final bool isVideo;
  const CallKitAccepted(super.callId, {this.isVideo = false});
}

class CallKitDeclined extends CallKitAction {
  const CallKitDeclined(super.callId);
}

class CallKitEnded extends CallKitAction {
  const CallKitEnded(super.callId);
}

class CallKitTimedOut extends CallKitAction {
  const CallKitTimedOut(super.callId);
}

class CallKitMissed extends CallKitAction {
  const CallKitMissed(super.callId);
}

/// Service for handling iOS CallKit events.
class CallKitEventHandler {
  final _actionController = StreamController<CallKitAction>.broadcast();
  StreamSubscription? _eventSubscription;

  /// Stream of CallKit actions
  Stream<CallKitAction> get actions => _actionController.stream;

  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Initialize and start listening to iOS CallKit events.
  void initialize() {
    _eventSubscription?.cancel();
    if (!_isIOS) {
      developer.log(
        'CallKitEventHandler skipped (non-iOS platform)',
        name: 'Notifications',
      );
      return;
    }

    developer.log('CallKitEventHandler initialized (iOS)', name: 'Notifications');
    _eventSubscription = FlutterCallkitIncoming.onEvent.listen(
      _handleEvent,
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'CallKit event stream error: $error',
          name: 'Notifications',
          stackTrace: stackTrace,
        );
      },
    );
  }

  void _handleEvent(CallEvent? event) {
    if (event == null) return;

    final body = _asMap(event.body);
    final extra = _asMap(body['extra']);
    final callId = _readFirstString([
      body['id'],
      body['callId'],
      body['uuid'],
      extra['callId'],
      extra['id'],
      extra['uuid'],
    ]);
    final isVideo = _readBool(extra['isVideo']) ||
        _readBool(body['isVideo']) ||
        (body['type'] == 1);

    developer.log('CallKit event: ${event.event} for $callId',
        name: 'Notifications');
    if (callId.isEmpty) {
      developer.log(
        'Ignoring CallKit event with missing call id: ${event.event}',
        name: 'Notifications',
      );
      return;
    }

    switch (event.event) {
      case Event.actionCallAccept:
        _actionController.add(CallKitAccepted(callId, isVideo: isVideo));
        break;

      case Event.actionCallDecline:
        _actionController.add(CallKitDeclined(callId));
        break;

      case Event.actionCallEnded:
        _actionController.add(CallKitEnded(callId));
        break;

      case Event.actionCallTimeout:
        _actionController.add(CallKitTimedOut(callId));
        break;

      case Event.actionDidUpdateDevicePushTokenVoip:
        final token = _readFirstString([body['devicePushTokenVoip']]);
        if (token.isNotEmpty) {
          final preview = token.length <= 20 ? token : token.substring(0, 20);
          developer.log('VoIP token updated: $preview...', name: 'Notifications');
        }
        break;

      default:
        developer.log('Unhandled CallKit event: ${event.event}',
            name: 'Notifications');
        break;
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map(
        (key, dynamic mapValue) => MapEntry(key.toString(), mapValue),
      );
    }
    return <String, dynamic>{};
  }

  String _readFirstString(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  /// Simulate a CallKit action (for testing without the package)
  void simulateAction(CallKitAction action) {
    _actionController.add(action);
  }

  /// Dispose resources
  void dispose() {
    _eventSubscription?.cancel();
    _actionController.close();
  }
}
