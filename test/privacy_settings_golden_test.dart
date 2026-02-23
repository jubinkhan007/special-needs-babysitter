import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/settings/privacy_settings/presentation/privacy_settings_screen.dart';

void main() {
  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PrivacySettingsScreen(),
      ),
    );
  }

  testWidgets('Privacy Settings Screen matches golden', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PrivacySettingsScreen),
      matchesGoldenFile('goldens/privacy_settings_screen.png'),
    );
  });
}
