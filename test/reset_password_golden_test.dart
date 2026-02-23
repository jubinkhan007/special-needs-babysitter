import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/settings/change_password/presentation/reset_password_screen.dart';

void main() {
  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResetPasswordScreen(),
      ),
    );
  }

  testWidgets('Reset Password Screen matches golden', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ResetPasswordScreen),
      matchesGoldenFile('goldens/reset_password_screen.png'),
    );
  });
}
