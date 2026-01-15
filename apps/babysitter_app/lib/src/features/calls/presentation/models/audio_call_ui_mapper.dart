import '../../domain/audio_call_state.dart';
import 'audio_call_ui_model.dart';

class AudioCallUiMapper {
  static AudioCallUiModel map(AudioCallState state) {
    String secondaryText;
    bool showLargeAvatar;
    bool showMediumAvatar;

    if (state.phase == AudioCallPhase.calling) {
      secondaryText = 'Calling...';
      showLargeAvatar = true;
      showMediumAvatar = false;
    } else {
      // Connected
      final seconds = state.elapsedSeconds ?? 0;
      secondaryText = _formatDuration(seconds);
      showLargeAvatar = false;
      showMediumAvatar = true;
    }

    return AudioCallUiModel(
      titleText: 'Special Needs Sitters',
      nameText: state.remoteName,
      secondaryText: secondaryText,
      showLargeAvatar: showLargeAvatar,
      showMediumAvatar: showMediumAvatar,
      avatarUrl: state.remoteAvatarUrl,
      isMicOn: state.isMicOn,
      isSpeakerOn: state.isSpeakerOn,
      isVideoEnabled: state.isVideoEnabled,
    );
  }

  static String _formatDuration(int totalSeconds) {
    if (totalSeconds < 0) return '00:00';
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
