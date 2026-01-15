import '../../domain/video_call_state.dart';
import 'video_call_ui_model.dart';

class VideoCallUiMapper {
  static VideoCallUiModel map(VideoCallState state) {
    return VideoCallUiModel(
      remoteName: state.remoteName,
      timerText: _formatDuration(state.elapsedSeconds),
      remoteVideoUrl: state.remoteVideoUrl,
      localPreviewUrl: state.localPreviewUrl,
      isMicOn: state.isMicOn,
      isSpeakerOn: state.isSpeakerOn,
      isCameraOn: state.isCameraOn,
      isFrontCamera: state.isFrontCamera,
    );
  }

  static String _formatDuration(int totalSeconds) {
    if (totalSeconds < 0) return '00:00';
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
