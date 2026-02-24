import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/realtime/realtime.dart';

import 'package:babysitter_app/src/features/messages/presentation/providers/chat_providers.dart';
import 'package:babysitter_app/src/features/calls/services/rtm_auth_state.dart';

class RtmConnectionManager {
  final Ref _ref;
  bool _connected = false;

  RtmConnectionManager(this._ref);

  bool get isConnected => _connected;

  Future<void> connect() async {
    if (_connected) return;

    final chatService = _ref.read(chatServiceProvider);
    final chatInit = await _ref.read(chatRepositoryProvider).initChat();

    developer.log(
      'RTM connect agoraUsername=${chatInit.agoraUsername} tokenLen=${chatInit.agoraToken.length}',
      name: 'RTM',
    );

    _ref.read(rtmAuthStateProvider.notifier).state = chatInit;
    _ref.read(rtmLoginUserIdProvider.notifier).state = chatInit.agoraUsername;

    await chatService.init();
    await chatService.login(
      userId: chatInit.agoraUsername,
      token: chatInit.agoraToken,
    );

    _connected = true;
    developer.log('RTM connection established', name: 'RTM');
  }

  Future<void> disconnect() async {
    if (!_connected) return;
    try {
      await _ref.read(chatServiceProvider).logout();
    } catch (e) {
      developer.log('RTM disconnect error: $e', name: 'RTM');
    }
    _connected = false;
    developer.log('RTM disconnected', name: 'RTM');
  }

  void dispose() {
    if (_connected) {
      disconnect();
    }
  }
}

final rtmConnectionManagerProvider = Provider<RtmConnectionManager>((ref) {
  final manager = RtmConnectionManager(ref);
  ref.onDispose(manager.dispose);
  return manager;
});
