import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/features/calls/domain/audio_call_state.dart';
import 'package:babysitter_app/src/features/calls/domain/audio_call_args.dart';

import 'models/audio_call_ui_mapper.dart';
import 'widgets/call_app_bar.dart';
import 'widgets/call_background.dart';
import 'widgets/call_status_block.dart';
import 'widgets/call_control_bar.dart';

class AudioCallScreen extends StatefulWidget {
  final AudioCallArgs args;

  const AudioCallScreen({super.key, required this.args});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late AudioCallState _state;

  @override
  void initState() {
    super.initState();
    // Initialize state from args
    _state = AudioCallState(
      remoteName: widget.args.remoteName,
      remoteAvatarUrl: widget.args.remoteAvatarUrl,
      phase: widget.args.isInitialCalling
          ? AudioCallPhase.calling
          : AudioCallPhase.connected,
      elapsedSeconds: widget.args.isInitialCalling ? null : 0,
    );

    // Mock transition/timer logic if needed for demo
    // For now, static state or simple toggle via UI actions for demo purposes
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

  void _toggleVideo() {
    setState(() {
      _state = _state.copyWith(isVideoEnabled: !_state.isVideoEnabled);
    });
  }

  void _endCall() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    // Map state to UI model
    final uiModel = AudioCallUiMapper.map(_state);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Background (Fills screen)
            const Positioned.fill(child: CallBackground()),

            // 2. Main Content Safe Area
            SafeArea(
              child: Column(
                children: [
                  // Top App Bar
                  CallAppBar(title: uiModel.titleText),

                  // Spacer dynamic
                  SizedBox(height: AppTokens.callVerticalSpacingLg),

                  // Center Status Block (Avatar + Name + Status)
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 20.h), // Tuning vertical pos
                        child: CallStatusBlock(
                          name: uiModel.nameText,
                          statusText: uiModel.secondaryText,
                          avatarUrl: uiModel.avatarUrl,
                          phase: _state.phase,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Floating Control Bar (Bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 20.h,
              child: Center(
                child: CallControlBar(
                  isVideoEnabled: uiModel.isVideoEnabled,
                  isSpeakerOn: uiModel.isSpeakerOn,
                  isMicOn: uiModel.isMicOn,
                  onEndCall: _endCall,
                  onToggleMic: _toggleMic,
                  onToggleSpeaker: _toggleSpeaker,
                  onToggleVideo: _toggleVideo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
