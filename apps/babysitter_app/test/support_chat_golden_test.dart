import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/support/presentation/support_chat_screen.dart';
import 'package:babysitter_app/src/features/support/domain/support_chat_args.dart';

void main() {
  setUpAll(() async {
    // ScreenUtil init
  });

  Widget createTestWidget(SupportChatArgs args) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14-ish
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter', // Assuming Inter or similar
          useMaterial3: true,
        ),
        home: SupportChatScreen(args: args),
      ),
    );
  }

  group('Support Chat Screen Goldens', () {
    testWidgets('State A (Initial Verification) matches golden',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));

      await tester.pumpWidget(createTestWidget(
        const SupportChatArgs(isInitialVerification: true),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SupportChatScreen),
        matchesGoldenFile('goldens/support_chat_state_a.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('State B (Access Denied / Prompt) matches golden',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));

      await tester.pumpWidget(createTestWidget(
        const SupportChatArgs(isInitialVerification: false),
      ));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SupportChatScreen),
        matchesGoldenFile('goldens/support_chat_state_b.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });
  });
}
