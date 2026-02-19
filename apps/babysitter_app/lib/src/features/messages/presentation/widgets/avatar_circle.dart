import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

/// Circular avatar for messages list.
/// Supports network images or system/app icon.
class AvatarCircle extends StatelessWidget {
  final String? imageUrl;
  final bool isSystem;

  const AvatarCircle({
    super.key,
    this.imageUrl,
    this.isSystem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTokens.messageAvatarSize,
      height: AppTokens.messageAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSystem ? AppTokens.systemAvatarBg : Colors.grey.shade200,
        border: isSystem
            ? Border.all(
                color: AppTokens.primaryBlue.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: isSystem
          ? const Center(
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 24,
                color: AppTokens.primaryBlue,
              ),
            )
          : (imageUrl != null && imageUrl!.isNotEmpty)
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: 28,
        color: Colors.grey.shade500,
      ),
    );
  }
}
