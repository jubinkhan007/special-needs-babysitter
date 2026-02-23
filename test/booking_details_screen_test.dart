import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/bookings/domain/booking_details.dart';
import 'package:babysitter_app/src/features/bookings/domain/booking_status.dart';
import 'package:babysitter_app/src/features/bookings/presentation/booking_details_screen.dart';

void main() {
  Widget createScreen(BookingStatus status) {
    return ScreenUtilInit(
      designSize:
          const Size(375, 812), // iPhone X/11 format often used in Figma
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BookingDetailsScreen(
            args: BookingDetailsArgs(
              bookingId: 'test-id',
              status: status,
            ),
          ),
        );
      },
    );
  }

  testWidgets('Booking Details Screen - Upcoming Variant Golden Test',
      (tester) async {
    await tester.pumpWidget(createScreen(BookingStatus.upcoming));
    await tester.pumpAndSettle();

    // Figma drift check: Ensure layout is stable
    await expectLater(
      find.byType(BookingDetailsScreen),
      matchesGoldenFile('goldens/booking_details_upcoming.png'),
    );
  });

  testWidgets('Booking Details Screen - Pending Variant Golden Test',
      (tester) async {
    await tester.pumpWidget(createScreen(BookingStatus.pending));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(BookingDetailsScreen),
      matchesGoldenFile('goldens/booking_details_pending.png'),
    );
  });

  testWidgets('Booking Details Screen - Completed Variant Golden Test',
      (tester) async {
    await tester.pumpWidget(createScreen(BookingStatus.completed));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(BookingDetailsScreen),
      matchesGoldenFile('goldens/booking_details_completed.png'),
    );
  });
}
