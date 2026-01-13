import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class BookingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.appBarBg,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: kToolbarHeight,
          decoration: const BoxDecoration(
            color: AppTokens.appBarBg,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.03),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: AppTokens.screenHorizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTokens.iconGrey),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text('Bookings', style: AppTokens.appBarTitle),
              IconButton(
                icon: const Icon(Icons.notifications_none,
                    color: AppTokens.iconGrey),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTokens.appBarHeight);
}
