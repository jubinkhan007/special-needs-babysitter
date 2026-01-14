import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';

class BookingDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const BookingDetailsAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.bookingDetailsHeaderBg, // Match page bg
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppTokens.appBarHeight,
          padding: const EdgeInsets.symmetric(
              horizontal: 4), // Adjust for IconButton padding
          decoration: BoxDecoration(
            // No shadow by default unless scrolled? Figma shows subtle shadow in header?
            // Plan said "Use exact shadow used in cards and header".
            // AppTokens.appBarShadow exists.
            color: AppTokens.bookingDetailsHeaderBg,
            boxShadow: AppTokens.appBarShadow,
          ),
          child: NavigationToolbar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppTokens.appBarTitleGrey),
              onPressed: () => context.pop(),
            ),
            middle: Text(
              title,
              style:
                  AppTokens.appBarTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.headset_mic_outlined,
                  color: AppTokens.appBarTitleGrey), // Headset icon
              onPressed: () {
                // Support action
              },
            ),
            centerMiddle: true,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppTokens.appBarHeight);
}
