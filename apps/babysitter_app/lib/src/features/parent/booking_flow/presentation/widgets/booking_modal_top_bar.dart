import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class BookingModalTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback onClose;

  const BookingModalTopBar({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: const Icon(
                Icons.close,
                size: 24, // Thin X
                color: BookingUiTokens.iconGrey,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: BookingUiTokens.modalTopBarTitle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
