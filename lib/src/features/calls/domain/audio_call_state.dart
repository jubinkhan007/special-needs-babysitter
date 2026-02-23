enum AudioCallPhase {
  calling,
  connected,
  ended,
}

class AudioCallState {
  final String remoteName;
  final String remoteAvatarUrl;
  final AudioCallPhase phase;
  final int? elapsedSeconds; // null if not connected
  final bool isMicOn;
  final bool isSpeakerOn;
  final bool isVideoEnabled; // Even for audio call, UI has toggle

  const AudioCallState({
    required this.remoteName,
    required this.remoteAvatarUrl,
    this.phase = AudioCallPhase.calling,
    this.elapsedSeconds,
    this.isMicOn = true,
    this.isSpeakerOn = false,
    this.isVideoEnabled = false,
  });

  AudioCallState copyWith({
    String? remoteName,
    String? remoteAvatarUrl,
    AudioCallPhase? phase,
    int? elapsedSeconds,
    bool? isMicOn,
    bool? isSpeakerOn,
    bool? isVideoEnabled,
  }) {
    return AudioCallState(
      remoteName: remoteName ?? this.remoteName,
      remoteAvatarUrl: remoteAvatarUrl ?? this.remoteAvatarUrl,
      phase: phase ?? this.phase,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isMicOn: isMicOn ?? this.isMicOn,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
    );
  }
}
