// bookings_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../../../../theme/app_tokens.dart';

class BookingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTokens.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: AppTokens.appBarHeight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTokens.iconGrey, size: 24),
        onPressed: () => context.go(Routes.parentHome),
      ),
      title: Text('Bookings', style: AppTokens.appBarTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none,
              color: AppTokens.iconGrey, size: 26),
          onPressed: () {},
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
