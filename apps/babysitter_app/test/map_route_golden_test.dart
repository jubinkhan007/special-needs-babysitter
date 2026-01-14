import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/bookings/presentation/map_route/map_route_screen.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MapRouteScreen(
            bookingId: 'test-booking-id',
          ),
        );
      },
    );
  }

  testWidgets('Map Route Screen - Golden Test', (tester) async {
    // 1. Pump
    await tester.pumpWidget(createScreen());

    // 2. Settle
    await tester.pumpAndSettle();

    // 3. Match golden
    await expectLater(
      find.byType(MapRouteScreen),
      matchesGoldenFile('goldens/map_route_screen.png'),
    );
  });
}
