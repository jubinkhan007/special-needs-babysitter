import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/features/settings/manage_notifications/presentation/manage_notifications_screen.dart';
import 'package:babysitter_app/src/features/settings/manage_notifications/models/notification_preferences.dart';
import 'package:babysitter_app/src/features/settings/manage_notifications/presentation/notification_preferences_providers.dart';

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        notificationPreferencesProvider.overrideWith(
          () => _FakeNotificationPreferencesNotifier(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ManageNotificationsScreen(),
        ),
      ),
    );
  }

  testWidgets('Manage Notifications Screen matches golden', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ManageNotificationsScreen),
      matchesGoldenFile('goldens/manage_notifications_screen.png'),
    );
  });
}

class _FakeNotificationPreferencesNotifier
    extends NotificationPreferencesNotifier {
  @override
  Future<NotificationPreferences> build() async {
    return const NotificationPreferences();
  }

  @override
  Future<void> toggle(String field, bool value) async {}
}
