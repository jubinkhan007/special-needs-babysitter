import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:realtime/realtime.dart';

import '../domain/entities/call_enums.dart';
import '../presentation/controllers/call_state.dart';
import '../presentation/providers/calls_providers.dart';
import '../../messages/presentation/providers/chat_providers.dart';
import 'call_navigation_guard.dart';
import 'rtm_auth_state.dart';

class RtmCallInviteHandler {
  final Ref _ref;
  final GlobalKey<NavigatorState> navigatorKey;

  StreamSubscription<ChatEvent>? _subscription;
  String? _lastHandledCallId;
  bool _initialized = false;

  RtmCallInviteHandler(this._ref, {required this.navigatorKey});

  Future<void> initialize({required String userId}) async {
    if (_initialized) return;
    _initialized = true;

    final chatService = _ref.read(chatServiceProvider);
    developer.log('RTM invite handler init userId=$userId', name: 'Calls');
    final chatInit = await _ref.read(chatRepositoryProvider).initChat();
    try {
      developer.log(
        'RTM chat init agoraUsername=${chatInit.agoraUsername} tokenLen=${chatInit.agoraToken.length}',
        name: 'Calls',
      );
      _ref.read(rtmAuthStateProvider.notifier).state = chatInit;
      _ref.read(rtmLoginUserIdProvider.notifier).state = chatInit.agoraUsername;
      await chatService.init();
      await chatService.login(
        userId: chatInit.agoraUsername,
        token: chatInit.agoraToken,
      );
    } catch (e) {
      developer.log('RTM login failed for call invites: $e', name: 'Calls');
    }

    _subscription = chatService.events.listen(_handleChatEvent);
    developer.log('RtmCallInviteHandler initialized', name: 'Calls');
  }

  void _handleChatEvent(ChatEvent event) {
    if (event is! MessageReceivedEvent) return;

    developer.log('RTM message received: ${event.text}', name: 'Calls');
    final payload = _parsePayload(event.text);
    if (payload == null) return;

    final type = payload['type'] as String?;
    if (type != 'call_invite') return;

    final callId = payload['callId'] as String? ?? '';
    if (callId.isEmpty || callId == _lastHandledCallId) return;

    _lastHandledCallId = callId;

    final callType = CallType.fromString(payload['callType'] as String? ?? 'audio');
    final callerName = payload['callerName'] as String? ?? 'Unknown';
    final callerUserId = payload['callerUserId'] as String? ?? '';
    final callerAvatar = payload['callerAvatar'] as String?;

    developer.log(
      'RTM call invite callId=$callId type=${callType.name} callerUserId=$callerUserId',
      name: 'Calls',
    );
    _ref.read(callControllerProvider.notifier).handleIncomingCall(
          callId: callId,
          callType: callType,
          callerName: callerName,
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
        );

    final state = _ref.read(callControllerProvider);
    if (state is! IncomingRinging || state.callId != callId) {
      return;
    }

    // Use navigation guard to prevent duplicate screens
    final guard = _ref.read(callNavigationGuardProvider(navigatorKey));
    guard.showIncomingCallScreen(
      callId: callId,
      callType: callType,
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
    );
  }

  Map<String, dynamic>? _parsePayload(String text) {
    try {
      final decoded = jsonDecode(text);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {}

    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      try {
        final decoded = jsonDecode(text.substring(start, end + 1));
        return decoded is Map<String, dynamic> ? decoded : null;
      } catch (_) {}
    }

    return null;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}

final rtmCallInviteHandlerProvider =
    Provider.family<RtmCallInviteHandler, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final handler = RtmCallInviteHandler(ref, navigatorKey: navigatorKey);
  ref.onDispose(handler.dispose);
  return handler;
});
