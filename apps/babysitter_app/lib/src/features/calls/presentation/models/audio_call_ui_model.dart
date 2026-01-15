class AudioCallUiModel {
  final String titleText;
  final String nameText;
  final String secondaryText; // "Calling..." or Timer "00:35"
  final bool showLargeAvatar;
  final bool showMediumAvatar;
  final String avatarUrl;

  // Control States
  final bool isMicOn;
  final bool isSpeakerOn;
  final bool isVideoEnabled;

  const AudioCallUiModel({
    required this.titleText,
    required this.nameText,
    required this.secondaryText,
    required this.showLargeAvatar,
    required this.showMediumAvatar,
    required this.avatarUrl,
    required this.isMicOn,
    required this.isSpeakerOn,
    required this.isVideoEnabled,
  });
}
