import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../theme/app_tokens.dart';

class MapRouteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapRouteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.mapRouteHeaderBg,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: NavigationToolbar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppTokens.appBarTitleGrey),
              onPressed: () => context.pop(),
            ),
            middle: Text(
              'Map Route',
              style:
                  AppTokens.appBarTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.headset_mic_outlined,
                  color: AppTokens.mapRouteIconColor),
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
  Size get preferredSize =>
      const Size.fromHeight(AppTokens.mapRouteHeaderHeight);
}
