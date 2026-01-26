import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/presentation/theme/home_design_tokens.dart';

import '../../routing/routes.dart';

/// Parent shell widget with bottom navigation
class ParentShell extends StatelessWidget {
  final Widget child;

  const ParentShell({super.key, required this.child});

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
    final selectedColor = HomeDesignTokens.bottomNavSelected;
    final unselectedColor = HomeDesignTokens.bottomNavUnselected;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
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
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (index) => _onItemTapped(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
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
              // Handle bookings png fallback if needed, or use SvgPicture if it was renamed
              // User file list showed ic_bookings.png
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
      ),
    );
  }
}
