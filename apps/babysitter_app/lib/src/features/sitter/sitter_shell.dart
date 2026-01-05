import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import '../../routing/routes.dart';

/// Sitter shell widget with bottom navigation
class SitterShell extends StatelessWidget {
  final Widget child;

  const SitterShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == Routes.sitterHome) return 0;
    if (location == Routes.sitterJobs) return 1;
    if (location == Routes.sitterBookings) return 2;
    if (location == Routes.sitterMessages) return 3;
    if (location == Routes.sitterAccount) return 4;
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
        context.go(Routes.sitterBookings);
        break;
      case 3:
        context.go(Routes.sitterMessages);
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Find Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
