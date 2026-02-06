import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:domain/domain.dart';
import '../../messages/presentation/providers/chat_providers.dart';
import '../domain/entities/call_enums.dart';
import '../presentation/controllers/call_state.dart';
import '../presentation/providers/calls_providers.dart';
import 'call_navigation_guard.dart';

class ChatCallInvitePollingHandler {
  final Ref _ref;
  final GlobalKey<NavigatorState> navigatorKey;

  Timer? _pollTimer;
  bool _isPolling = false;
  bool _isTicking = false;
  final Set<String> _handledCallIds = {};
  final DateTime _startedAt = DateTime.now();

  ChatCallInvitePollingHandler(this._ref, {required this.navigatorKey});

  void start() {
    if (_isPolling) return;
    _isPolling = true;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _poll();
    developer.log('ChatCallInvitePollingHandler started', name: 'Calls');
  }

  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _isPolling = false;
    _isTicking = false;
    developer.log('ChatCallInvitePollingHandler stopped', name: 'Calls');
  }

  Future<void> _poll() async {
    if (_isTicking) return;
    _isTicking = true;
    try {
      final callState = _ref.read(callControllerProvider);
      if (callState is InCall ||
          callState is OutgoingRinging ||
          callState is IncomingRinging) {
        return;
      }

      final conversations =
          await _ref.read(chatRepositoryProvider).getConversations();

      for (final convo in conversations) {
        final otherUserId = convo.id;
        if (otherUserId.isEmpty) continue;

        final messages =
            await _ref.read(chatRepositoryProvider).getMessages(otherUserId);
        if (messages.isEmpty) continue;

        final recent = List<ChatMessageEntity>.from(messages)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        for (final message in recent.take(5)) {
          final payload = _parsePayload(message.textContent ?? '');
          if (payload == null) continue;
          if ((payload['type'] as String?) != 'call_invite') continue;

          final callId = payload['callId'] as String? ?? '';
          if (callId.isEmpty || _handledCallIds.contains(callId)) continue;

          if (message.createdAt.isBefore(
            _startedAt.subtract(const Duration(seconds: 10)),
          )) {
            continue;
          }

          final callType = CallType.fromString(
            payload['callType'] as String? ?? 'audio',
          );
          final callerName = payload['callerName'] as String? ?? 'Unknown';
          final callerUserId = payload['callerUserId'] as String? ?? '';
          final callerAvatar = payload['callerAvatar'] as String?;

          _handledCallIds.add(callId);
          developer.log('Chat call invite detected callId=$callId', name: 'Calls');

          _ref.read(callControllerProvider.notifier).handleIncomingCall(
                callId: callId,
                callType: callType,
                callerName: callerName,
                callerUserId: callerUserId,
                callerAvatar: callerAvatar,
              );

          final state = _ref.read(callControllerProvider);
          if (state is! IncomingRinging || state.callId != callId) {
            continue;
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

          return;
        }
      }
    } catch (e) {
      developer.log('Chat call invite polling error: $e', name: 'Calls');
    } finally {
      _isTicking = false;
    }
  }

  Map<String, dynamic>? _parsePayload(String text) {
    if (text.isEmpty) return null;
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
    stop();
  }
}

final chatCallInvitePollingHandlerProvider =
    Provider.family<ChatCallInvitePollingHandler, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final handler = ChatCallInvitePollingHandler(ref, navigatorKey: navigatorKey);
  ref.onDispose(() => handler.dispose());
  return handler;
});
