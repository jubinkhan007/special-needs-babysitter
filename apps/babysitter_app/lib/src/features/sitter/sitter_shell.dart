import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../parent/home/presentation/theme/home_design_tokens.dart';

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
    final selectedColor = HomeDesignTokens.bottomNavSelected;
    final unselectedColor = HomeDesignTokens.bottomNavUnselected;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: HomeDesignTokens.bottomNavHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_home.svg',
                colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_home.svg',
                colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_jobs.svg',
                colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_jobs.svg',
                colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
              ),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/bottom_nav/ic_bookings.png',
                color: unselectedColor,
                width: 24,
                height: 24,
              ),
              activeIcon: Image.asset(
                'assets/icons/bottom_nav/ic_bookings.png',
                color: selectedColor,
                width: 24,
                height: 24,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_messages.svg',
                colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_messages.svg',
                colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_account.svg',
                colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bottom_nav/ic_account.svg',
                colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
