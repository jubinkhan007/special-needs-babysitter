import 'package:babysitter_app/src/features/calls/domain/video_call_args.dart';
import 'package:babysitter_app/src/features/calls/presentation/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Mocking network images for goldens is tricky as they don't load real pixels.
// We rely on the layout structure being correct.
// Ideally usage of local assets for goldens is better, but code uses network.
// We'll proceed and see if we can at least verify widget tree and structure.

void main() {
  setUpAll(() async {
    // ScreenUtil init
  });

  Widget createTestWidget(VideoCallArgs args) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: VideoCallScreen(args: args),
      ),
    );
  }

  testWidgets('Video Call Screen - Connected State matches golden',
      (tester) async {
    const args = VideoCallArgs(
      remoteName: 'Krystina',
      remoteVideoUrl: 'https://example.com/video_placeholder.jpg',
      localPreviewUrl: 'https://example.com/local_preview.jpg',
    );

    tester.view.physicalSize = const Size(1179, 2556); // iPhone 14 Pro 3x
    tester.view.devicePixelRatio = 3.0;

    // Use mockNetworkImagesFor helper if available, or just pump.
    // For Golden tests, standard network images usually render transparent or error placeholder.
    // Our RemoteVideoSurface has an error builder which is a black container with icon.
    // This is good for stable goldens.

    await tester.pumpWidget(createTestWidget(args));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VideoCallScreen),
      matchesGoldenFile('goldens/video_call_connected.png'),
    );
  });
}
