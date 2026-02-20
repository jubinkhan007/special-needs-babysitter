import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../theme/app_tokens.dart';
import '../models/chat_message_ui_model.dart';

/// Message bubble with tailored shape and styling matching Figma.
class MessageBubble extends StatelessWidget {
  final ChatMessageUiModel uiModel;

  const MessageBubble({super.key, required this.uiModel});

  @override
  Widget build(BuildContext context) {
    // If it's me, right align. usage of Row MainAxisAlignment.end
    final isMe = uiModel.isMe;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.chatHorizontalPadding,
        vertical: 6, // Vertical gap between messages
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Meta Header (Name • Time)
          if (uiModel.headerMetaLeft != null || uiModel.headerMetaRight != null)
            Padding(
              padding: EdgeInsets.only(
                  bottom: 4,
                  left: isMe ? 0 : 48,
                  right: isMe ? 48 : 0), // Align with bubble content
              child: Text(
                isMe ? uiModel.headerMetaRight! : uiModel.headerMetaLeft!,
                style: AppTokens.chatMetaStyle,
              ),
            ),

          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for sender (Left side)
              if (!isMe && uiModel.showAvatar) ...[
                CircleAvatar(
                  radius: 20,
                  backgroundImage: uiModel.avatarUrl != null
                      ? NetworkImage(uiModel.avatarUrl!)
                      : null,
                  backgroundColor: Colors.grey.shade300,
                  child: uiModel.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white, size: 20)
                      : null,
                ),
                const SizedBox(width: 8),
              ],

              // If not showing avatar but is sender, add spacing to align
              // if (isMe && !uiModel.showAvatar) const SizedBox(width: 48),

              // The Bubble with Custom Tail
              Flexible(
                child: CustomPaint(
                  painter: _BubbleTailPainter(
                    color: isMe
                        ? AppTokens.chatBubbleOutgoingBg
                        : AppTokens.chatBubbleIncomingBg,
                    isMe: isMe,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppTokens.chatBubbleOutgoingBg
                          : AppTokens.chatBubbleIncomingBg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppTokens.chatBubbleRadius),
                        topRight: Radius.circular(AppTokens.chatBubbleRadius),
                        bottomLeft: isMe
                            ? Radius.circular(AppTokens.chatBubbleRadius)
                            : const Radius.circular(0), // Tail side
                        bottomRight: isMe
                            ? const Radius.circular(0) // Tail side
                            : Radius.circular(AppTokens.chatBubbleRadius),
                      ),
                    ),
                    child: _MessageBubbleContent(
                      uiModel: uiModel,
                      isMe: isMe,
                    ),
                  ),
                ),
              ),

              // Avatar for me (Right side)
              if (isMe && uiModel.showAvatar) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: uiModel.avatarUrl != null
                      ? NetworkImage(uiModel.avatarUrl!)
                      : null,
                  backgroundColor: Colors.grey.shade300,
                  child: uiModel.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white, size: 20)
                      : null,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubbleContent extends StatelessWidget {
  final ChatMessageUiModel uiModel;
  final bool isMe;

  const _MessageBubbleContent({
    required this.uiModel,
    required this.isMe,
  });

  bool get _hasMedia =>
      uiModel.mediaUrl != null &&
      uiModel.mediaUrl!.isNotEmpty &&
      (uiModel.mediaType ?? 'text') != 'text';

  bool get _isImage => uiModel.mediaType == 'image';

  IconData _mediaIcon() {
    switch (uiModel.mediaType) {
      case 'video':
        return Icons.videocam_outlined;
      case 'audio':
        return Icons.audiotrack_outlined;
      case 'file':
        return Icons.insert_drive_file_outlined;
      default:
        return Icons.attach_file;
    }
  }

  Future<void> _openMediaUrl() async {
    final url = uiModel.mediaUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        isMe ? AppTokens.chatBubbleOutgoingText : AppTokens.textPrimary;
    final textStyle = AppTokens.chatMessageTextStyle.copyWith(color: textColor);

    if (!_hasMedia) {
      return Text(uiModel.bubbleText, style: textStyle);
    }

    if (_isImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _openMediaUrl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                uiModel.mediaUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
          if (uiModel.bubbleText.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(uiModel.bubbleText, style: textStyle),
          ],
        ],
      );
    }

    final fileLabel = uiModel.fileName ??
        (uiModel.mediaUrl?.split('/').last.split('?').first ?? 'Attachment');

    return GestureDetector(
      onTap: _openMediaUrl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_mediaIcon(), size: 20, color: textColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              fileLabel,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  _BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (isMe) {
      // Bottom Right Tail - Sharper/Cleaner
      final w = size.width;
      final h = size.height;
      const r = 16.0; // Radius matches bubble radius

      path.moveTo(w - r, h); // Start at bottom edge before corner
      path.arcToPoint(
        Offset(w, h - r),
        radius: const Radius.circular(r),
        clockwise: false,
      ); // Draw the rounded corner normally first? No, we need to extend it.

      // Actually, let's draw a simple sharp tail sticking out
      // Reset path for just the tail to be drawn on top or appended?
      // CustomPainter draws on top of child usually if size matches?
      // Let's draw the tail extension.

      path.reset();
      path.moveTo(w, h - 20); // Start nicely above bottom
      path.quadraticBezierTo(w, h, w + 8, h); // Curve out to point
      path.lineTo(w - 10, h); // Line back to bottom edge
      path.close();
    } else {
      // Bottom Left Tail (not shown in screenshot for incoming actually, mainly rounded)
      // BUT if we wanted it:
      // path.moveTo(0, size.height - 16);
      // path.quadraticBezierTo(0, size.height, -tailSize, size.height);
      // path.lineTo(10, size.height);
      // path.close();
    }

    // Screenshot shows only outgoing has the sharp tail. Incoming is just rounded bubble.
    if (isMe) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
