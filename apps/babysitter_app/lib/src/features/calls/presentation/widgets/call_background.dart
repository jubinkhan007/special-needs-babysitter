import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class CallBackground extends StatelessWidget {
  const CallBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Reusing the chat background style as requested (subtle gradient/light leak)
    return Container(
      color: AppTokens.callBg,
      child: Stack(
        children: [
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
                    AppTokens.primaryBlue.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
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
                    AppTokens.primaryBlue.withValues(alpha: 0.03),
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
