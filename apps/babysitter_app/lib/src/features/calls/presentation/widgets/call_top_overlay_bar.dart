import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class CallTopOverlayBar extends StatelessWidget {
  final String title;
  final String timerText;
  final VoidCallback onMinimize;

  const CallTopOverlayBar({
    super.key,
    required this.title,
    required this.timerText,
    required this.onMinimize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.callTopBarHPadding,
        vertical: AppTokens.callTopBarVPadding,
      ),
      child: Stack(
        children: [
          // Left Icon
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onMinimize,
              child: Icon(
                Icons.open_in_full_rounded, // Using same icon as audio
                color: AppTokens.callOverlayIcon,
                size: AppTokens.callTopIconSize,
              ),
            ),
          ),

          // Center Title
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppTokens.callTopNameStyle,
              textAlign: TextAlign.center,
            ),
          ),

          // Right Timer
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              timerText,
              style: AppTokens.callTopTimerStyle,
            ),
          ),
        ],
      ),
    );
  }
}
