import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/settings/presentation/dialogs/delete_account_dialog.dart';

void main() {
  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: DeleteAccountDialog(),
          ),
        ),
      ),
    );
  }

  testWidgets('Delete Account Dialog matches golden', (tester) async {
    // Set a consistent surface size for the test
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify the dialog specifically
    await expectLater(
      find.byType(DeleteAccountDialog),
      matchesGoldenFile('goldens/delete_account_dialog.png'),
    );

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
}
