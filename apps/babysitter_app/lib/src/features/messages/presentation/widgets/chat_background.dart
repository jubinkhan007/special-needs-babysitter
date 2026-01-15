import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class ChatBackground extends StatelessWidget {
  const ChatBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Implementing the subtle arc/gradient background using CustomPaint or Container decoration.
    // Given the difficulty of matching specific vector art without assets,
    // we will use a subtle gradient that mimics the light leak effect.
    return Container(
      color: AppTokens.chatScreenBg,
      child: Stack(
        children: [
          // Top right subtle blue glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTokens.primaryBlue.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom left subtle blue glow
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTokens.primaryBlue.withOpacity(0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
