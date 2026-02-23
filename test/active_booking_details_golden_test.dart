import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/bookings/presentation/active_booking_details_screen.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ActiveBookingDetailsScreen(
            bookingId: 'test-active-id',
          ),
        );
      },
    );
  }

  testWidgets('Active Booking Details Screen - Golden Test', (tester) async {
    // 1. Pump the widget
    await tester.pumpWidget(createScreen());

    // 2. Wait for animations/rendering
    await tester.pumpAndSettle();

    // 3. Match golden file
    await expectLater(
      find.byType(ActiveBookingDetailsScreen),
      matchesGoldenFile('goldens/active_booking_details.png'),
    );
  });
}
