import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/message_thread_ui_model.dart';
import 'avatar_circle.dart';
import 'verified_badge.dart';
import 'unread_badge.dart';

/// A single row in the messages list.
/// Custom Row (not ListTile) for pixel-perfect control.
class MessageThreadTile extends StatelessWidget {
  final MessageThreadUiModel uiModel;
  final VoidCallback? onTap;

  const MessageThreadTile({
    super.key,
    required this.uiModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.messageRowHorizontalPadding,
              vertical: AppTokens.messageRowVerticalPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                AvatarCircle(
                  imageUrl: uiModel.avatarUrl,
                  isSystem: uiModel.isSystemThread,
                ),
                SizedBox(width: 12),

                // Center Column: Name + Preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name row with verified badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              uiModel.title,
                              style: AppTokens.messageNameStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (uiModel.isVerified) ...[
                            SizedBox(width: 4),
                            const VerifiedBadge(),
                          ],
                        ],
                      ),
                      SizedBox(height: AppTokens.rowGapNameToPreview),

                      // Preview row with optional call icon
                      Row(
                        children: [
                          if (uiModel.showCallEndedIcon) ...[
                            Icon(
                              Icons.call_made_rounded,
                              size: 14,
                              color: AppTokens.messagePreviewColor,
                            ),
                            SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              uiModel.previewText,
                              style: AppTokens.messagePreviewStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Column: Time + Unread Badge
                SizedBox(
                  width: AppTokens.trailingColumnWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        uiModel.timeText,
                        style: AppTokens.messageTimeStyle,
                      ),
                      if (uiModel.unreadCount > 0) ...[
                        SizedBox(height: 8),
                        UnreadBadge(count: uiModel.unreadCount),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: EdgeInsets.only(
              left: AppTokens.messageRowHorizontalPadding +
                  AppTokens.messageAvatarSize +
                  12,
            ),
            child: Container(
              height: AppTokens.messageDividerHeight,
              color: AppTokens.messageRowDivider,
            ),
          ),
        ],
      ),
    );
  }
}
