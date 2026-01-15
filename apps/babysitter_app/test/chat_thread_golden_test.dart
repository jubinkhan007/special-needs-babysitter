import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/messages/presentation/chat_thread_screen.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ChatThreadScreen(),
        );
      },
    );
  }

  testWidgets('Chat Thread Screen - Golden Test', (tester) async {
    // 1. Pump widget
    await tester.pumpWidget(createScreen());

    // 2. Wait for rendering (and any images/animations)
    await tester.pumpAndSettle();

    // 3. Match golden file
    await expectLater(
      find.byType(ChatThreadScreen),
      matchesGoldenFile('goldens/chat_thread_screen.png'),
    );
  });
}
