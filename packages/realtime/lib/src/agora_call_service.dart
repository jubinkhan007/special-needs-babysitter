import 'dart:async';
import 'dart:developer' as developer;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:core/core.dart';

import 'call_service.dart';
import 'token/agora_token_provider.dart';

/// Agora RTC implementation of CallService
class AgoraCallService implements CallService {
  final AgoraTokenProvider _tokenProvider;
  final String _appId;

  RtcEngine? _engine;
  final _eventsController = StreamController<CallEvent>.broadcast();
  bool _isInitialized = false;

  AgoraCallService({required AgoraTokenProvider tokenProvider, String? appId})
    : _tokenProvider = tokenProvider,
      _appId = appId ?? EnvConfig.agoraAppId;

  @override
  Future<void> initialize() async {
    if (_appId.isEmpty) {
      throw const ConfigFailure(
        message: 'Agora App ID not configured. Set AGORA_APP_ID in .env file.',
      );
    }

    if (_isInitialized) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _setupEventHandlers();
    _isInitialized = true;

    developer.log('AgoraCallService initialized', name: 'Realtime');
  }

  void _setupEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          developer.log(
            'Joined channel: ${connection.channelId}',
            name: 'Realtime',
          );
          _eventsController.add(
            CallJoinedEvent(
              channel: connection.channelId ?? '',
              uid: connection.localUid ?? 0,
            ),
          );
        },
        onLeaveChannel: (connection, stats) {
          developer.log('Left channel', name: 'Realtime');
          _eventsController.add(CallLeftEvent());
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          developer.log('User joined: $remoteUid', name: 'Realtime');
          _eventsController.add(UserJoinedEvent(uid: remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          developer.log('User left: $remoteUid', name: 'Realtime');
          _eventsController.add(UserLeftEvent(uid: remoteUid));
        },
        onError: (err, msg) {
          developer.log('Call error: $err - $msg', name: 'Realtime');
          _eventsController.add(CallErrorEvent(message: msg, code: err.index));
        },
        onUserMuteAudio: (connection, remoteUid, muted) {
          _eventsController.add(
            UserMuteAudioEvent(uid: remoteUid, muted: muted),
          );
        },
        onUserMuteVideo: (connection, remoteUid, muted) {
          _eventsController.add(
            UserMuteVideoEvent(uid: remoteUid, muted: muted),
          );
        },
      ),
    );
  }

  @override
  Future<void> joinChannel({
    required String channelName,
    required int uid,
    String? token,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Get token from provider if not provided
    final effectiveToken =
        token ?? await _tokenProvider.getRtcToken(channelName, uid);

    await _engine!.enableAudio();
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine!.joinChannel(
      token: effectiveToken ?? '',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishMicrophoneTrack: true,
        publishCameraTrack: true,
      ),
    );
  }

  @override
  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  @override
  Future<void> muteLocalAudio(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  @override
  Future<void> enableLocalVideo(bool enable) async {
    if (enable) {
      await _engine?.enableVideo();
    } else {
      await _engine?.disableVideo();
    }
  }

  @override
  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  @override
  Future<void> enableSpeakerphone(bool enable) async {
    await _engine?.setEnableSpeakerphone(enable);
  }

  @override
  Stream<CallEvent> get events => _eventsController.stream;

  @override
  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    _isInitialized = false;
    await _eventsController.close();
  }
}
