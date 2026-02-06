import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/chat_message_ui_model.dart';

class CallLogTile extends StatelessWidget {
  final ChatMessageUiModel uiModel;

  const CallLogTile({super.key, required this.uiModel});

  @override
  Widget build(BuildContext context) {
    final isVideo = uiModel.isVideoCall;
    final isMissed = uiModel.isMissedCall;

    // Choose icon based on call type
    IconData callIcon;
    Color iconColor = AppTokens.messageNameColor;
    
    if (isMissed) {
      callIcon = isVideo ? Icons.videocam_off_outlined : Icons.call_missed_outlined;
      iconColor = Colors.red;
    } else if (uiModel.isMe) {
      // Outgoing call
      callIcon = isVideo ? Icons.videocam_outlined : Icons.call_made_outlined;
    } else {
      // Incoming call
      callIcon = isVideo ? Icons.videocam_outlined : Icons.call_received_outlined;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.chatHorizontalPadding,
        vertical: 8,
      ),
      child: Align(
        alignment: Alignment.center, // Center align like WhatsApp
        child: Container(
          width: 0.75 * MediaQuery.of(context).size.width, // Max width
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTokens.callTileBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Icon + Title
              Row(
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  Icon(
                    callIcon,
                    size: 16,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    uiModel.callTitle ?? 'Call',
                    style: AppTokens.callTileTitleStyle,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Row 2: Duration (if available) + Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Duration or status
                  if (uiModel.callSubtitle != null && uiModel.callSubtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        uiModel.callSubtitle!,
                        style: AppTokens.callTileSubStyle,
                      ),
                    )
                  else
                    const Spacer(),
                  // Time
                  Text(
                    uiModel.callTime ?? '',
                    style: AppTokens.chatMetaStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
