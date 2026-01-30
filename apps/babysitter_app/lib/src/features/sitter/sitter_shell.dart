import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../../common_widgets/custom_bottom_nav_bar.dart';

/// Sitter shell widget with bottom navigation
class SitterShell extends StatelessWidget {
  final Widget child;

  const SitterShell({super.key, required this.child});

  static const List<CustomNavItem> _navItems = [
    CustomNavItem(
      label: 'Home',
      svgAssetPath: 'assets/icons/bottom_nav/ic_home.svg',
    ),
    CustomNavItem(
      label: 'Jobs',
      svgAssetPath: 'assets/icons/bottom_nav/ic_jobs.svg',
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
      label: 'Account',
      svgAssetPath: 'assets/icons/bottom_nav/ic_account.svg',
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == Routes.sitterHome) return 0;
    if (location.startsWith(Routes.sitterJobs)) return 1;
    // Messages has sub-routes like /sitter/messages/chat/:id, so use startsWith
    if (location.startsWith(Routes.sitterMessages)) return 2;
    if (location.startsWith(Routes.sitterBookings)) return 3;
    if (location.startsWith(Routes.sitterAccount)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.sitterHome);
        break;
      case 1:
        context.go(Routes.sitterJobs);
        break;
      case 2:
        context.go(Routes.sitterMessages);
        break;
      case 3:
        context.go(Routes.sitterBookings);
        break;
      case 4:
        context.go(Routes.sitterAccount);
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
