import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

/// Dark circular badge showing unread message count.
class UnreadBadge extends StatelessWidget {
  final int count;

  const UnreadBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      width: AppTokens.unreadBadgeSize,
      height: AppTokens.unreadBadgeSize,
      decoration: const BoxDecoration(
        color: AppTokens.unreadBadgeBg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: AppTokens.unreadBadgeTextStyle,
        ),
      ),
    );
  }
}
