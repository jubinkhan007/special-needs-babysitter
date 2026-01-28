import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../../common_widgets/custom_bottom_nav_bar.dart';

/// Parent shell widget with bottom navigation
class ParentShell extends StatelessWidget {
  final Widget child;

  const ParentShell({super.key, required this.child});

  static const List<CustomNavItem> _navItems = [
    CustomNavItem(
      label: 'Home',
      svgAssetPath: 'assets/icons/bottom_nav/ic_home.svg',
    ),
    CustomNavItem(
      label: 'Messages',
      svgAssetPath: 'assets/icons/bottom_nav/ic_messages.svg',
    ),
    CustomNavItem(
      label: 'Bookings',
      pngAssetPath: 'assets/icons/bottom_nav/ic_bookings.png',
    ),
    CustomNavItem(
      label: 'Jobs',
      svgAssetPath: 'assets/icons/bottom_nav/ic_jobs.svg',
    ),
    CustomNavItem(
      label: 'Account',
      svgAssetPath: 'assets/icons/bottom_nav/ic_account.svg',
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == Routes.parentHome) return 0;
    if (location == Routes.parentMessages) return 1;
    if (location == Routes.parentBookings) return 2;
    if (location == Routes.parentJobs) return 3;
    // Account has sub-routes like /parent/account/profile, so use startsWith
    if (location.startsWith(Routes.parentAccount)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.parentHome);
        break;
      case 1:
        context.go(Routes.parentMessages);
        break;
      case 2:
        context.go(Routes.parentBookings);
        break;
      case 3:
        context.go(Routes.parentJobs);
        break;
      case 4:
        context.go(Routes.parentAccount);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        items: _navItems,
      ),
    );
  }
}
