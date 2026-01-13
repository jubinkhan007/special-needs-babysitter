import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_status.dart';

class BookingsTabs extends StatelessWidget {
  final TabController controller;
  final List<BookingStatus> tabs;

  const BookingsTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.bg,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      padding: EdgeInsets.symmetric(vertical: AppTokens.tabsVerticalPadding),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        padding:
            EdgeInsets.symmetric(horizontal: AppTokens.screenHorizontalPadding),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          color: AppTokens.primaryBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTokens.textSecondary,
        labelStyle: AppTokens.tabSelected,
        unselectedLabelStyle: AppTokens.tabUnselected,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        tabs: tabs.map((status) {
          final label = status.name[0].toUpperCase() + status.name.substring(1);
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}
