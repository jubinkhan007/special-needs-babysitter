import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class UserMessageBubble extends StatelessWidget {
  final String text;
  final String metaText; // "4:27 PM • You"
  final String? userAvatarUrl;

  const UserMessageBubble({
    super.key,
    required this.text,
    required this.metaText,
    this.userAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment
            .center, // Avatar is centered vertically relative to bubble? No, usually bottom or top. Screenshot looks vaguely centered or top aligned.
        children: [
          SizedBox(width: 40.w), // Left spacer

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Meta
                Text(
                  metaText,
                  style: AppTokens.chatMetaStyle,
                ),
                SizedBox(height: 4.h),

                // Bubble Container with Tail
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment
                      .end, // Align bubble bottom with avatar?
                  children: [
                    Flexible(
                      child: CustomPaint(
                        painter:
                            _BubbleTailPainter(color: AppTokens.userBubbleBg),
                        child: Container(
                          padding: EdgeInsets.all(AppTokens.bubblePadding),
                          decoration: BoxDecoration(
                            color: AppTokens.userBubbleBg,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  AppTokens.supportBubbleRadius),
                              bottomLeft: Radius.circular(
                                  AppTokens.supportBubbleRadius),
                              topRight: Radius.circular(
                                  AppTokens.supportBubbleRadius),
                              // Bottom right has tail, so maybe less radius? handled by painter or generic radius
                              bottomRight: const Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            text,
                            style: AppTokens.chatBubbleStyle.copyWith(
                              color: AppTokens.userBubbleText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // User Avatar
          if (userAvatarUrl != null)
            CircleAvatar(
              radius: AppTokens.userAvatarSize / 2,
              backgroundImage: NetworkImage(userAvatarUrl!),
              backgroundColor: Colors.grey[200],
            )
          else
            CircleAvatar(
              radius: AppTokens.userAvatarSize / 2,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;

  _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // No-op for now as decided.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
