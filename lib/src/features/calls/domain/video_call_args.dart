class VideoCallArgs {
  final String remoteName;
  final String remoteVideoUrl; // URL or placeholder identifier
  final String localPreviewUrl; // URL or placeholder identifier

  const VideoCallArgs({
    required this.remoteName,
    required this.remoteVideoUrl,
    required this.localPreviewUrl,
  });
}
