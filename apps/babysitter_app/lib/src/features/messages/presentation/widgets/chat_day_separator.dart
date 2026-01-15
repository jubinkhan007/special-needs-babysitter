import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class ChatDaySeparator extends StatelessWidget {
  final String text;

  const ChatDaySeparator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Text(
          text,
          style: AppTokens.chatMetaStyle,
        ),
      ),
    );
  }
}
