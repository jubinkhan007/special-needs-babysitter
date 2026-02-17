// bookings_tabs.dart
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

  String _label(BookingStatus status) {
    final n = status.name;
    return n[0].toUpperCase() + n.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.surfaceWhite,
      child: Container(
        height: AppTokens.tabsHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          left:
              AppTokens.screenHorizontalPadding, // EXACT left start like Figma
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,

          // ✅ Make tabs start from the very left (Flutter 3.7+)
          tabAlignment: TabAlignment.start,

          // ✅ Remove TabBar's own padding so it doesn't center/offset
          padding: EdgeInsets.zero,

          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,

          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            color: AppTokens.primaryBlue,
            borderRadius: BorderRadius.circular(AppTokens.tabPillRadius),
          ),

          // ✅ spacing between pills (use labelPadding, not container padding)
          labelPadding: const EdgeInsets.only(right: 14),

          labelColor: Colors.white,
          unselectedLabelColor: AppTokens.textPrimary,
          labelStyle: AppTokens.tabSelected,
          unselectedLabelStyle: AppTokens.tabUnselected,

          tabs: tabs.map((status) {
            return Tab(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(_label(status)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
