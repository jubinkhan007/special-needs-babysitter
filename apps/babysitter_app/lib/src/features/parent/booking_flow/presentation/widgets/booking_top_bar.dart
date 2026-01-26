import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class BookingTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onHelp;

  const BookingTopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: NavigationToolbar(
          leading: GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: BookingUiTokens.iconGrey,
            ),
          ),
          middle: Text(
            title,
            style: BookingUiTokens.topBarTitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: GestureDetector(
            onTap: onHelp,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: BookingUiTokens.iconGrey,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.question_mark_rounded,
                size: 16,
                color: BookingUiTokens.iconGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
