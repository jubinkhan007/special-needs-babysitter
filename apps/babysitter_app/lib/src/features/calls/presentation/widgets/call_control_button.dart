import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final bool isDestructive; // for End Call button
  final VoidCallback onTap;
  final bool
      isActive; // e.g. mic on/off state visual if needed (usually changing icon or bg)

  const CallControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive
        ? AppTokens.callEndButtonBg
        : AppTokens.callControlButtonBg;

    final size = isDestructive
        ? AppTokens.callEndButtonSize
        : AppTokens.callControlButtonSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          // Optional shadow if required by pixel perfect spec
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: AppTokens.callControlIconColor,
          size: AppTokens.callControlIconSize, // or custom size if needed
        ),
      ),
    );
  }
}
