import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class ActiveBottomCtaBar extends StatelessWidget {
  final VoidCallback onMessageTap;
  final VoidCallback onCallTap;

  const ActiveBottomCtaBar({
    super.key,
    required this.onMessageTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.screenBg,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.detailsHorizontalPadding,
            vertical: AppTokens.bottomBarPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildButton('Message', onMessageTap),
              ),
              const SizedBox(width: AppTokens.bottomCtaGap),
              Expanded(
                child: _buildButton('Call', onCallTap),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppTokens.bottomCtaHeight),
        backgroundColor: AppTokens.primaryBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.bottomCtaRadius),
        ),
      ),
      child: Text(
        label,
        style: AppTokens.buttonText,
      ),
    );
  }
}
