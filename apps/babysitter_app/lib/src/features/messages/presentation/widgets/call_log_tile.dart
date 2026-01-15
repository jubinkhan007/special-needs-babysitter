import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/chat_message_ui_model.dart';

class CallLogTile extends StatelessWidget {
  final ChatMessageUiModel uiModel;

  const CallLogTile({super.key, required this.uiModel});

  @override
  Widget build(BuildContext context) {
    // Screenshot has:
    // Icon (diagonal arrow)  Title
    //                        Subtitle    Time

    // Actually the design is:
    // Row(Icon, Column(Title, Row(Subtitle, Spacer, Time)))

    final isVideo = uiModel.isVideoCall;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.chatHorizontalPadding,
        vertical: 8,
      ),
      child: Align(
        alignment: uiModel.isVideoCall
            ? Alignment.centerRight
            : Alignment.centerLeft, // Missed video aligned right in screenshot
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
              // Row 1: Icon + Title + (Optional Video Icon at end)
              Row(
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  if (!isVideo) ...[
                    Icon(
                      uiModel.isMissedCall
                          ? Icons.call_missed_outlined
                          : Icons.call_received_outlined,
                      // Screenshot: Voice Call has arrow down-left (received), Missed has bounced.
                      // Using outlined variants for lighter weight.
                      size: 16,
                      color: AppTokens.messageNameColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    uiModel.callTitle ?? 'Call',
                    style: AppTokens.callTileTitleStyle,
                  ),
                  if (isVideo) ...[
                    const SizedBox(width: 8),
                    // Video icon on the right of title
                    const Icon(Icons.videocam_outlined,
                        size: 18, color: AppTokens.messageNameColor),
                  ]
                ],
              ),
              const SizedBox(height: 4),

              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isVideo) ...[
                    // Missed Video Call (Right Aligned in Screen)
                    // Snapshot: Time on Left, Duration on Right
                    Text(
                      uiModel.callTime ?? '',
                      style: AppTokens.chatMetaStyle,
                    ),
                    Text(
                      uiModel.callSubtitle ?? '',
                      style: AppTokens.callTileSubStyle,
                    ),
                  ] else ...[
                    // Voice Call (Left Aligned in Screen)
                    // Snapshot: Duration on Left (indented), Time on Right
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        uiModel.callSubtitle ?? '',
                        style: AppTokens.callTileSubStyle,
                      ),
                    ),
                    Text(
                      uiModel.callTime ?? '',
                      style: AppTokens.chatMetaStyle,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
