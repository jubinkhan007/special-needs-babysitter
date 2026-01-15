import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/audio_call_state.dart';
import 'call_avatar.dart';

class CallStatusBlock extends StatelessWidget {
  final String name;
  final String statusText; // "Calling..." or "00:35"
  final String? avatarUrl;
  final AudioCallPhase phase;

  const CallStatusBlock({
    super.key,
    required this.name,
    required this.statusText,
    required this.avatarUrl,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    if (phase == AudioCallPhase.calling) {
      // Calling State: Avatar -> Name -> "Calling..."
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CallAvatar(
            avatarUrl: avatarUrl,
            size: AppTokens.callAvatarLargeSize,
          ),
          SizedBox(height: AppTokens.callVerticalSpacingMd),
          Text(
            name,
            style: AppTokens.callNameLargeStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTokens.callVerticalSpacingSm),
          Text(
            statusText,
            style: AppTokens.callStatusStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // Connected State: Name -> Timer -> Avatar
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: AppTokens.callNameMediumStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTokens.callVerticalSpacingSm),
          Text(
            statusText,
            style: AppTokens.callTimerStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTokens.callVerticalSpacingMd),
          CallAvatar(
            avatarUrl: avatarUrl,
            size: AppTokens.callAvatarMediumSize,
          ),
        ],
      );
    }
  }
}
