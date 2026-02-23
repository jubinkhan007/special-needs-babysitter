class AudioCallArgs {
  final String remoteName;
  final String remoteAvatarUrl;
  final bool isInitialCalling; // true if starting as outgoing call

  const AudioCallArgs({
    required this.remoteName,
    required this.remoteAvatarUrl,
    this.isInitialCalling = true,
  });
}
