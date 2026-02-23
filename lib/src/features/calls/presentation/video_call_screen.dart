import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/features/calls/domain/video_call_state.dart';
import 'package:babysitter_app/src/features/calls/domain/video_call_args.dart';

import 'models/video_call_ui_mapper.dart';
import 'widgets/remote_video_surface.dart';
import 'widgets/call_top_overlay_bar.dart';
import 'widgets/pip_preview_tile.dart';
import 'widgets/call_control_bar.dart';

class VideoCallScreen extends StatefulWidget {
  final VideoCallArgs args;

  const VideoCallScreen({super.key, required this.args});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late VideoCallState _state;

  @override
  void initState() {
    super.initState();
    // Initialize state
    _state = VideoCallState(
      remoteName: widget.args.remoteName,
      remoteVideoUrl: widget.args.remoteVideoUrl,
      localPreviewUrl: widget.args.localPreviewUrl,
      elapsedSeconds: 35, // Mock start at 00:35 as per req
    );
  }

  void _toggleMic() {
    setState(() {
      _state = _state.copyWith(isMicOn: !_state.isMicOn);
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _state = _state.copyWith(isSpeakerOn: !_state.isSpeakerOn);
    });
  }

  void _toggleCamera() {
    // This toggles local camera stream on/off (UI state)
    setState(() {
      _state = _state.copyWith(isCameraOn: !_state.isCameraOn);
    });
  }

  void _switchCamera() {
    // This switches front/back camera (Pip button)
    setState(() {
      _state = _state.copyWith(isFrontCamera: !_state.isFrontCamera);
    });
  }

  void _endCall() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    // Map state to UI model
    final uiModel = VideoCallUiMapper.map(_state);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Layer A: Remote Video (Full Screen)
            Positioned.fill(
              child: RemoteVideoSurface(videoUrl: uiModel.remoteVideoUrl),
            ),

            // Layer B: Top Overlay Bar (Transparent)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: CallTopOverlayBar(
                  title: uiModel.remoteName,
                  timerText: uiModel.timerText,
                  onMinimize: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),

            // Layer C: PIP Preview Tile (Bottom-Right)
            // "Sits above control bar and does not overlap it"
            Positioned(
              right: AppTokens.pipMarginRight,
              bottom: AppTokens.callControlsBarHeight +
                  AppTokens.pipMarginBottom +
                  MediaQuery.of(context).padding.bottom +
                  20.h,
              // Control bar is approx 80h + padding.
              // Let's ensure it clears it.
              // Logic: ControlBar is at bottom + 20.h (margin) + safeArea.
              // So Pip should be above that.
              child: PipPreviewTile(
                previewUrl: uiModel.localPreviewUrl,
                onSwitchCamera: _switchCamera,
              ),
            ),

            // Layer D: Bottom Control Bar (Frosted/Translucent)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 20.h,
              child: Center(
                child: CallControlBar(
                  backgroundColor: AppTokens.callControlBarBgVideo,
                  isVideoEnabled: uiModel.isCameraOn,
                  isSpeakerOn: uiModel.isSpeakerOn,
                  isMicOn: uiModel.isMicOn,
                  onEndCall: _endCall,
                  onToggleMic: _toggleMic,
                  onToggleSpeaker: _toggleSpeaker,
                  onToggleVideo: _toggleCamera,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
