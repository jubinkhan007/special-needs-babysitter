class VideoCallState {
  final String remoteName;
  final String remoteVideoUrl;
  final String localPreviewUrl;

  // Call status
  final int elapsedSeconds;

  // Toggles
  final bool isMicOn;
  final bool isSpeakerOn;
  final bool isCameraOn; // Local camera toggle
  final bool isFrontCamera; // Pip switch toggle

  const VideoCallState({
    required this.remoteName,
    required this.remoteVideoUrl,
    required this.localPreviewUrl,
    this.elapsedSeconds = 0,
    this.isMicOn = true,
    this.isSpeakerOn = true,
    this.isCameraOn = true, // Default video call acts as video on
    this.isFrontCamera = true,
  });

  VideoCallState copyWith({
    String? remoteName,
    String? remoteVideoUrl,
    String? localPreviewUrl,
    int? elapsedSeconds,
    bool? isMicOn,
    bool? isSpeakerOn,
    bool? isCameraOn,
    bool? isFrontCamera,
  }) {
    return VideoCallState(
      remoteName: remoteName ?? this.remoteName,
      remoteVideoUrl: remoteVideoUrl ?? this.remoteVideoUrl,
      localPreviewUrl: localPreviewUrl ?? this.localPreviewUrl,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isMicOn: isMicOn ?? this.isMicOn,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
    );
  }
}
