import 'dart:async';
import 'dart:developer' as developer;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:core/core.dart';

import 'call_service.dart';
import 'token/agora_token_provider.dart';

/// Agora RTC implementation of CallService
class AgoraCallService implements CallService {
  final AgoraTokenProvider _tokenProvider;
  String _appId;

  RtcEngine? _engine;
  final _eventsController = StreamController<CallEvent>.broadcast();
  bool _isInitialized = false;
  String? _currentChannelName;

  AgoraCallService({required AgoraTokenProvider tokenProvider, String? appId})
    : _tokenProvider = tokenProvider,
      _appId = appId ?? EnvConfig.agoraAppId;

  /// Get the underlying RTC engine (for video views)
  RtcEngine? get engine => _engine;

  @override
  bool get isInitialized => _isInitialized;

  @override
  String? get currentChannelName => _currentChannelName;

  @override
  Future<void> initialize({String? appId}) async {
    // Allow overriding appId from backend config
    if (appId != null && appId.isNotEmpty) {
      _appId = appId;
    }

    if (_appId.isEmpty) {
      throw const ConfigFailure(
        message: 'Agora App ID not configured. Provide appId or set AGORA_APP_ID in .env file.',
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

    developer.log('AgoraCallService initialized with appId: ${_appId.substring(0, 8)}...', name: 'Realtime');
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
        onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
          final muted = state == RemoteVideoState.remoteVideoStateStopped;
          _eventsController.add(
            UserMuteVideoEvent(uid: remoteUid, muted: muted),
          );
        },
        onTokenPrivilegeWillExpire: (connection, token) {
          developer.log('Token will expire soon', name: 'Realtime');
          _eventsController.add(TokenPrivilegeWillExpireEvent(token: token));
        },
      ),
    );
  }

  @override
  Future<void> joinChannel({
    required String channelName,
    required int uid,
    String? token,
    bool enableVideo = false,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Fix for error -17: If already in a channel, leave it first
    if (_currentChannelName != null) {
      developer.log(
        'Already in channel $_currentChannelName, leaving before joining $channelName',
        name: 'Realtime',
      );
      await _engine?.leaveChannel();
      _currentChannelName = null;
      // Small delay to ensure channel is fully left
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Get token from provider if not provided
    final effectiveToken =
        token ?? await _tokenProvider.getRtcToken(channelName, uid);

    await _engine!.enableAudio();
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // Only enable video for video calls
    if (enableVideo) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
      developer.log('Video enabled for call', name: 'Realtime');
    }

    await _engine!.joinChannel(
      token: effectiveToken ?? '',
      channelId: channelName,
      uid: uid,
      options: ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: enableVideo,
        publishMicrophoneTrack: true,
        publishCameraTrack: enableVideo,
      ),
    );

    _currentChannelName = channelName;
    developer.log('Joined channel: $channelName (video: $enableVideo)', name: 'Realtime');
  }

  @override
  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
    _currentChannelName = null;
  }

  @override
  Future<void> renewToken(String token) async {
    if (_engine == null) {
      developer.log('Cannot renew token: engine not initialized', name: 'Realtime');
      return;
    }
    await _engine!.renewToken(token);
    developer.log('RTC token renewed', name: 'Realtime');
  }

  @override
  Future<void> muteLocalAudio(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  @override
  Future<void> enableLocalVideo(bool enable) async {
    if (enable) {
      await _engine?.enableVideo();
      await _engine?.startPreview();
      developer.log('Video enabled and preview started', name: 'Realtime');
    } else {
      await _engine?.stopPreview();
      await _engine?.disableVideo();
      developer.log('Video disabled and preview stopped', name: 'Realtime');
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
