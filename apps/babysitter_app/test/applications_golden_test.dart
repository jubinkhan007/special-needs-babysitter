import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/jobs/presentation/applications/applications_screen.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ApplicationsScreen(jobId: 'test-job-id'),
        );
      },
    );
  }

  testWidgets('Applications Screen - Golden Test', (tester) async {
    // 1. Pump widget
    await tester.pumpWidget(createScreen());

    // 2. Wait for rendering
    await tester.pumpAndSettle();

    // 3. Match golden file
    await expectLater(
      find.byType(ApplicationsScreen),
      matchesGoldenFile('goldens/applications_screen.png'),
    );
  });
}
