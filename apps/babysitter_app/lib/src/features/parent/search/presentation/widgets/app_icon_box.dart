import 'package:flutter/material.dart';
import '../theme/app_ui_tokens.dart';

class AppIconBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const AppIconBox({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppUiTokens.bookmarkBoxSize,
        height: AppUiTokens.bookmarkBoxSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppUiTokens.radiusSmall),
          border: Border.all(color: AppUiTokens.iconBoxBorder),
        ),
        child: Icon(
          icon,
          size: AppUiTokens.iconSizeMedium,
          color: AppUiTokens.textSecondary,
        ),
      ),
    );
  }
}
