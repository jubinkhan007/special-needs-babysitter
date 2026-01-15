class VideoCallUiModel {
  final String remoteName;
  final String timerText; // "00:35"
  final String remoteVideoUrl;
  final String localPreviewUrl;

  // States
  final bool isMicOn;
  final bool isSpeakerOn;
  final bool isCameraOn;
  final bool isFrontCamera;

  const VideoCallUiModel({
    required this.remoteName,
    required this.timerText,
    required this.remoteVideoUrl,
    required this.localPreviewUrl,
    required this.isMicOn,
    required this.isSpeakerOn,
    required this.isCameraOn,
    required this.isFrontCamera,
  });
}
