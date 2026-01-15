import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import 'call_control_button.dart';

class CallControlBar extends StatelessWidget {
  // Config
  final Color? backgroundColor;

  // States
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final bool isMicOn;

  // Actions
  final VoidCallback onEndCall;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onToggleVideo;

  const CallControlBar({
    super.key,
    this.backgroundColor,
    required this.isVideoEnabled,
    required this.isSpeakerOn,
    required this.isMicOn,
    required this.onEndCall,
    required this.onToggleMic,
    required this.onToggleSpeaker,
    required this.onToggleVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth * AppTokens.callControlsBarWidthFactor,
      height: AppTokens.callControlsBarHeight,
      padding:
          EdgeInsets.symmetric(horizontal: AppTokens.callControlsBarPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTokens.callControlBarBg,
        borderRadius: BorderRadius.circular(AppTokens.callControlsBarRadius),
        // Add subtle shadow if needed
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Video Toggle
          CallControlButton(
            icon: isVideoEnabled
                ? Icons.videocam_rounded
                : Icons.videocam_off_rounded,
            onTap: onToggleVideo,
          ),

          // Speaker
          CallControlButton(
            icon: isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_up_outlined,
            onTap: onToggleSpeaker,
          ),

          // Mic
          CallControlButton(
            icon: isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
            onTap: onToggleMic,
          ),

          // End Call
          CallControlButton(
            icon: Icons.call_end_rounded,
            isDestructive: true,
            onTap: onEndCall,
          ),
        ],
      ),
    );
  }
}
