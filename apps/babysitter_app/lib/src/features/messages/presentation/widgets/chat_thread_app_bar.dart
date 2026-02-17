import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import 'avatar_circle.dart';
import 'verified_badge.dart';

class ChatThreadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final bool isVerified;
  final VoidCallback? onBack;
  final VoidCallback? onVideoCall;
  final VoidCallback? onVoiceCall;

  const ChatThreadAppBar({
    super.key,
    required this.title,
    this.avatarUrl,
    this.isVerified = false,
    this.onBack,
    this.onVideoCall,
    this.onVoiceCall,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppTokens.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.chatHeaderBg,
        boxShadow: AppTokens.appBarShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppTokens.appBarHeight,
          child: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppTokens.iconGrey,
                  size: 24,
                ),
              ),

              // Avatar
              AvatarCircle(
                imageUrl: avatarUrl,
                // Using a smaller size for app bar if needed, but reusing standard for now
                // Ideally passing size param to AvatarCircle would be better, but assuming scaling works
              ),
              const SizedBox(width: 8),

              // Title Row
              Expanded(
                child: Row(
                  children: [
                    Text(
                      title,
                      style:
                          AppTokens.chatSenderNameStyle.copyWith(fontSize: 16),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const VerifiedBadge(),
                    ],
                  ],
                ),
              ),

              // Actions
              IconButton(
                onPressed: onVideoCall,
                icon: const Icon(
                  Icons.videocam_rounded,
                  size: 28,
                  color: Colors.black87, // Color directly on Icon
                ),
              ),
              IconButton(
                onPressed: onVoiceCall,
                icon: const Icon(
                  Icons.call_rounded,
                  size: 28,
                  color: Colors.black87, // Color directly on Icon
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
