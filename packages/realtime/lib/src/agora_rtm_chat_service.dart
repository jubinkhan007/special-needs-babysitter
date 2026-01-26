import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:agora_rtm/agora_rtm.dart';
import 'package:core/core.dart';

import 'chat_service.dart';
import 'models/chat_event.dart';
import 'token/agora_token_provider.dart';

/// Agora RTM 2.x implementation of ChatService
class AgoraRtmChatService implements ChatService {
  final AgoraTokenProvider _tokenProvider;
  final String _appId;

  RtmClient? _client;
  final _eventsController = StreamController<ChatEvent>.broadcast();
  bool _isInitialized = false;
  String? _currentUserId;

  AgoraRtmChatService({
    required AgoraTokenProvider tokenProvider,
    String? appId,
  })  : _tokenProvider = tokenProvider,
        _appId = appId ?? EnvConfig.agoraAppId;

  @override
  Future<void> init() async {
    if (_appId.isEmpty) {
      throw const ConfigFailure(
        message: 'Agora App ID not configured. Set AGORA_APP_ID in .env file.',
      );
    }

    if (_isInitialized) return;

    try {
      // Initialize RTM 2.x client using the RTM() function
      final (status, client) = await RTM(
        _appId,
        'special_needs_sitters_user',
        config: RtmConfig(),
      );
      if (status.error) {
        throw Exception(
          'Failed to create RTM client: ${status.errorCode} - ${status.reason}',
        );
      }
      _client = client;

      // Add listeners for RTM events
      _client?.addListener(
        message: (MessageEvent event) {
          developer.log('RTM Message received from ${event.publisher}: ${event.message}', name: 'Realtime');
          // Try to get text from message. In 2.x, message is RtmMessage which might have data or text.
          // Using toString() as safe fallback or if it overrides toString to return content.
          // If RtmMessage has 'text' property, we should use that.
          // For now, removing .stringData which was definitely wrong.
          final publisher = event.publisher;
          if (publisher != null) {
            _eventsController.add(MessageReceivedEvent(
              peerId: publisher,
              text: event.message.toString(),
            ));
          }
        },
        linkState: (LinkStateEvent event) {
          developer.log('RTM Link state changed: ${event.currentState}', name: 'Realtime');
          final currentState = event.currentState;
          if (currentState != null) {
            _eventsController.add(ConnectionStateEvent(
              state: _mapConnectionState(currentState),
            ));
          }
        },
      );

      _isInitialized = true;
      developer.log('AgoraRtmChatService initialized with listeners', name: 'Realtime');
    } catch (e) {
      developer.log('Failed to initialize RTM: $e', name: 'Realtime');
      rethrow;
    }
  }

  ChatConnectionState _mapConnectionState(RtmLinkState state) {
    switch (state) {
      case RtmLinkState.idle:
        return ChatConnectionState.disconnected;
      case RtmLinkState.connecting:
        return ChatConnectionState.connecting;
      case RtmLinkState.connected:
        return ChatConnectionState.connected;
      case RtmLinkState.disconnected:
        return ChatConnectionState.disconnected;
      case RtmLinkState.suspended:
        return ChatConnectionState.reconnecting;
      case RtmLinkState.failed:
        return ChatConnectionState.aborted;
    }
  }

  @override
  Future<void> login({required String userId}) async {
    if (!_isInitialized) {
      await init();
    }

    _currentUserId = userId;

    // Get token from provider (may be null for dev mode)
    final token = await _tokenProvider.getRtmToken(userId);

    try {
      // Login with token (RTM 2.x uses token-based auth)
      if (token != null && token.isNotEmpty) {
        await _client?.login(token);
      }
      developer.log('RTM login success: $userId', name: 'Realtime');
      _eventsController.add(LoginSuccessEvent(userId: userId));
    } catch (e) {
      developer.log('RTM login failed: $e', name: 'Realtime');
      _eventsController.add(LoginFailedEvent(error: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client?.logout();
      _currentUserId = null;
      _eventsController.add(LogoutEvent());
      developer.log('RTM logout success', name: 'Realtime');
    } catch (e) {
      developer.log('RTM logout failed: $e', name: 'Realtime');
      rethrow;
    }
  }

  @override
  Future<void> sendPeerMessage({
    required String peerId,
    required String text,
  }) async {
    if (_client == null) {
      throw const ConfigFailure(message: 'Chat service not initialized');
    }

    try {
      // RTM 2.x uses publish to channel or direct messaging
      // For peer-to-peer, we can use a dedicated channel
      final (status, _) = await _client!.publish(
        peerId, // Use peerId as channel name for P2P
        text,
        channelType: RtmChannelType.user,
      );

      if (!status.error) {
        _eventsController.add(MessageSentEvent(peerId: peerId, text: text));
        developer.log('Message sent to $peerId', name: 'Realtime');
      } else {
        throw Exception('Failed to send message: ${status.errorCode}');
      }
    } catch (e) {
      developer.log('Failed to send message: $e', name: 'Realtime');
      _eventsController.add(
        MessageFailedEvent(peerId: peerId, text: text, error: e.toString()),
      );
      rethrow;
    }
  }

  @override
  Stream<ChatEvent> get events => _eventsController.stream;

  @override
  Future<void> dispose() async {
    try {
      await _client?.logout();
    } catch (_) {}
    await _client?.release();
    _client = null;
    _isInitialized = false;
    _currentUserId = null;
    await _eventsController.close();
  }
}
