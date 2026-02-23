import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class SupportChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onVideoCall;
  final VoidCallback onAudioCall;

  const SupportChatAppBar({
    super.key,
    required this.onBackPressed,
    required this.onVideoCall,
    required this.onAudioCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.chatHeaderBg, // Pale blue
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: AppTokens.chatHPadding,
        right: AppTokens.chatHPadding,
      ),
      alignment: Alignment.center,
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            // Back Arrow
            IconButton(
              onPressed: onBackPressed,
              icon: Icon(
                Icons
                    .arrow_back_ios_new_rounded, // Use specific arrow icon from library
                color: AppTokens.chatHeaderIconColor,
                size: 20.w,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            SizedBox(width: 8.w),

            // Headset Badge - Dark circular bagde with headset
            Container(
              width: 32.w,
              height: 32.w,
              decoration: const BoxDecoration(
                color: AppTokens.chatSupportBadgeBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.headset_mic_rounded,
                color: AppTokens.chatSupportBadgeIcon, // white
                size: 18.w,
              ),
            ),

            SizedBox(width: 8.w),

            // Title "Initial Live Chat"
            Flexible(
              child: Text(
                "Initial Live Chat",
                style: AppTokens.chatHeaderTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Spacer(),

            // Video Call Icon
            IconButton(
              onPressed: onVideoCall,
              icon: Icon(
                Icons.videocam_outlined,
                color: AppTokens.chatHeaderIconColor,
                size: 26.w,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            SizedBox(width: 16.w),

            // Phone Icon
            IconButton(
              onPressed: onAudioCall,
              icon: Icon(
                Icons.phone_outlined,
                color: AppTokens.chatHeaderIconColor,
                size: 24.w,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
