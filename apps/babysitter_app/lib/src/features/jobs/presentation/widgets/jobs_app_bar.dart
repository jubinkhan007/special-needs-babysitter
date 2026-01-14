import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import 'package:go_router/go_router.dart';

class JobsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSupportIcon;

  const JobsAppBar({
    super.key,
    this.title = 'All Jobs',
    this.showSupportIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.jobsAppBarBg,
        boxShadow: AppTokens.jobsAppBarShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: NavigationToolbar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppTokens.jobsAppBarIconColor),
              onPressed: () => context.pop(),
            ),
            middle: Text(
              title,
              style: AppTokens.jobsAppBarTitleStyle,
            ),
            trailing: IconButton(
              icon: Icon(
                showSupportIcon
                    ? Icons.headset_mic_outlined
                    : Icons.notifications_outlined,
                color: AppTokens.jobsAppBarIconColor,
              ),
              onPressed: () {
                // Notification or support action
              },
            ),
            centerMiddle: true,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
