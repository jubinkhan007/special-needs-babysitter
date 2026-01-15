import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class SupportMessageBubble extends StatelessWidget {
  final String text;
  final String metaText; // "Support • 4:27 PM"
  final bool showAvatar;

  const SupportMessageBubble({
    super.key,
    required this.text,
    required this.metaText,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h), // Gap between messages
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Column (Left)
          SizedBox(
            width: AppTokens.supportAvatarSize,
            child: showAvatar
                ? Container(
                    width: AppTokens.supportAvatarSize,
                    height: AppTokens.supportAvatarSize,
                    decoration: const BoxDecoration(
                      color: AppTokens
                          .chatSupportBadgeBg, // Recycling badge color logic for consistency
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.headset_mic_rounded,
                      color: AppTokens.chatSupportBadgeIcon,
                      size: 20.w,
                    ),
                  )
                : null,
          ),

          SizedBox(width: 8.w),

          // Message Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta Text
                if (showAvatar) ...[
                  Text(
                    metaText,
                    style: AppTokens.chatMetaStyle,
                  ),
                  SizedBox(height: 4.h),
                ],

                // Bubble
                Container(
                  constraints:
                      BoxConstraints(maxWidth: AppTokens.supportBubbleMaxWidth),
                  padding: EdgeInsets.all(AppTokens.bubblePadding),
                  decoration: BoxDecoration(
                    color: AppTokens.supportBubbleBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(showAvatar
                          ? 0
                          : AppTokens
                              .supportBubbleRadius), // Squarish if avatar logic requires? Screenshot shows rounded always
                      topRight: Radius.circular(AppTokens.supportBubbleRadius),
                      bottomLeft:
                          Radius.circular(AppTokens.supportBubbleRadius),
                      bottomRight:
                          Radius.circular(AppTokens.supportBubbleRadius),
                    ).copyWith(
                      topLeft: const Radius.circular(
                          12), // Actually standard rounded
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: AppTokens.chatBubbleStyle,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 40.w), // Spacer to prevent full width
        ],
      ),
    );
  }
}
