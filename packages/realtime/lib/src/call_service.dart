/// Interface for voice/video call service
abstract interface class CallService {
  /// Initialize the call engine
  Future<void> initialize();

  /// Join a call channel
  Future<void> joinChannel({
    required String channelName,
    required int uid,
    String? token,
  });

  /// Leave the current channel
  Future<void> leaveChannel();

  /// Mute/unmute local audio
  Future<void> muteLocalAudio(bool mute);

  /// Enable/disable local video
  Future<void> enableLocalVideo(bool enable);

  /// Switch camera (front/back)
  Future<void> switchCamera();

  /// Enable/disable speaker phone
  Future<void> enableSpeakerphone(bool enable);

  /// Stream of call events
  Stream<CallEvent> get events;

  /// Dispose resources
  Future<void> dispose();
}

/// Events emitted during a call
sealed class CallEvent {}

class CallJoinedEvent extends CallEvent {
  final String channel;
  final int uid;
  CallJoinedEvent({required this.channel, required this.uid});
}

class CallLeftEvent extends CallEvent {}

class UserJoinedEvent extends CallEvent {
  final int uid;
  UserJoinedEvent({required this.uid});
}

class UserLeftEvent extends CallEvent {
  final int uid;
  UserLeftEvent({required this.uid});
}

class CallErrorEvent extends CallEvent {
  final String message;
  final int? code;
  CallErrorEvent({required this.message, this.code});
}

class UserMuteAudioEvent extends CallEvent {
  final int uid;
  final bool muted;
  UserMuteAudioEvent({required this.uid, required this.muted});
}

class UserMuteVideoEvent extends CallEvent {
  final int uid;
  final bool muted;
  UserMuteVideoEvent({required this.uid, required this.muted});
}
