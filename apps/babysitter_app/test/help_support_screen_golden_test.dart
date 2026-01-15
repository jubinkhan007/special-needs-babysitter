import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/account/help_support/presentation/help_support_screen.dart';

void main() {
  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14 / 15 Pro roughly
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HelpSupportScreen(),
      ),
    );
  }

  testWidgets('Help Support Screen matches golden', (tester) async {
    // Lock device size to iPhone 13 (390x844) as per requirements
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(HelpSupportScreen),
      matchesGoldenFile('goldens/help_support_screen.png'),
    );
  });
}
