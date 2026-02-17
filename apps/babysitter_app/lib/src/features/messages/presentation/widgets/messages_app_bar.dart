import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

/// Custom app bar for Messages screen matching existing app bar style.
class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNotification;
  final bool showBackButton;

  const MessagesAppBar({
    super.key,
    this.onBack,
    this.onNotification,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppTokens.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.messagesHeaderBg,
        boxShadow: AppTokens.appBarShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppTokens.appBarHeight,
          child: Row(
            children: [
              // Back Button
              if (showBackButton)
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppTokens.iconGrey,
                    size: 24,
                  ),
                )
              else
                const SizedBox(width: 16), // Spacing if no back button

              // Title (Centered)
              Expanded(
                child: Center(
                  child: Text(
                    'Messages',
                    style: AppTokens.messagesTitleStyle,
                  ),
                ),
              ),

              // Notification Icon
              IconButton(
                onPressed: onNotification,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTokens.iconGrey,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
