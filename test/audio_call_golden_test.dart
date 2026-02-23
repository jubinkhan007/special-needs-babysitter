import 'package:babysitter_app/src/features/calls/domain/audio_call_args.dart';
import 'package:babysitter_app/src/features/calls/presentation/audio_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  setUpAll(() async {
    // Ensure ScreenUtil is initialized (mocking size usually handled by test env wrapped in ScreenUtilInit)
  });

  Widget createTestWidget(AudioCallArgs args) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AudioCallScreen(args: args),
      ),
    );
  }

  testWidgets('Audio Call Screen - Calling State matches golden',
      (tester) async {
    const args = AudioCallArgs(
      remoteName: 'Krystina',
      remoteAvatarUrl:
          'https://example.com/avatar.png', // Won't load in test, defaults to placeholder logic
      isInitialCalling: true,
    );

    // Set surface size to match iPhone design
    tester.view.physicalSize = const Size(1179, 2556); // 393 * 3
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(createTestWidget(args));
    await tester.pumpAndSettle(); // Wait for any animations

    // In golden tests, network images usually fail or show placeholder.
    // We expect the placeholder UI implementation to render cleanly.

    await expectLater(
      find.byType(AudioCallScreen),
      matchesGoldenFile('goldens/audio_call_calling.png'),
    );
  });

  testWidgets('Audio Call Screen - Connected State matches golden',
      (tester) async {
    const args = AudioCallArgs(
      remoteName: 'Krystina',
      remoteAvatarUrl: 'https://example.com/avatar.png',
      isInitialCalling: false, // Connected
    );

    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(createTestWidget(args));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(AudioCallScreen),
      matchesGoldenFile('goldens/audio_call_connected.png'),
    );
  });
}
