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
    return AppBar(
      backgroundColor: AppTokens.bookingDetailsHeaderBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: AppTokens.appBarHeight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTokens.iconGrey, size: 24),
        onPressed: () => context.pop(),
      ),
      title: Text(title, style: AppTokens.appBarTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.headset_mic_outlined,
              color: AppTokens.iconGrey, size: 24),
          onPressed: () {
            // Support action
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color.fromRGBO(0, 0, 0, 0.03), // very subtle line
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppTokens.appBarHeight + 1);
}
