import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class CallAppBar extends StatelessWidget {
  final String title;

  const CallAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTokens.appBarHeight,
      padding:
          EdgeInsets.symmetric(horizontal: AppTokens.callHorizontalPadding),
      alignment: Alignment.centerLeft, // Or center depending on details
      // Figma shows left icon, center title.
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left Action
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                // Minimize or other action - mockup shows diagonal arrows
              },
              icon: const Icon(
                Icons
                    .open_in_full_rounded, // Best match for diagonal expand arrows or similar
                // Actually screenshot shows "un-fullscreen" or distinct icon?
                // Let's use generic expand/collapse or custom if needed.
                // Screenshot shows top-left double arrow like 'minimize' or 'fullscreen_exit'.
                // Using generic for now.
                size: 24,
                color: AppTokens
                    .callHeaderText, // Or grey? Screenshot title is black, icon is grey.
                // Let's assume grey for icon as typical.
              ),
              color: AppTokens.iconGrey,
            ),
          ),

          // Center Title
          Text(
            title,
            style: AppTokens.callTitleStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
