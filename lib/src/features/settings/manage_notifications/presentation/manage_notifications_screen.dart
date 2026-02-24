import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/common_widgets/app_toggle_tile.dart';

import 'notification_preferences_providers.dart';

class ManageNotificationsScreen extends ConsumerWidget {
  const ManageNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: AppTokens.settingsBg,
      appBar: AppBar(
        backgroundColor: AppTokens.settingsBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTokens.appBarTitleColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Manage Notifications',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: AppTokens.appBarTitleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTokens.appBarTitleColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SafeArea(
          child: prefsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Failed to load preferences',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamily,
                      fontSize: 16.sp,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => ref.invalidate(notificationPreferencesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (prefs) {
              final pushEnabled = prefs.pushNotifications;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTokens.settingsHPad.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppTokens.settingsTopPad.h),

                    // — General —
                    _SectionHeader(title: 'General'),
                    SizedBox(height: 8.h),
                    AppToggleTile(
                      title: 'Push Notifications',
                      value: prefs.pushNotifications,
                      onChanged: (v) => ref
                          .read(notificationPreferencesProvider.notifier)
                          .toggle('pushNotifications', v),
                    ),

                    SizedBox(height: 20.h),

                    // — Jobs —
                    _SectionHeader(title: 'Jobs'),
                    SizedBox(height: 8.h),
                    _disableableToggle(
                      enabled: pushEnabled,
                      child: AppToggleTile(
                        title: 'Job Updates',
                        value: prefs.jobUpdates && pushEnabled,
                        onChanged: pushEnabled
                            ? (v) => ref
                                .read(notificationPreferencesProvider.notifier)
                                .toggle('jobUpdates', v)
                            : (_) {},
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // — Messages & Reminders —
                    _SectionHeader(title: 'Messages & Reminders'),
                    SizedBox(height: 8.h),
                    _disableableToggle(
                      enabled: pushEnabled,
                      child: AppToggleTile(
                        title: 'Messages',
                        value: prefs.messages && pushEnabled,
                        onChanged: pushEnabled
                            ? (v) => ref
                                .read(notificationPreferencesProvider.notifier)
                                .toggle('messages', v)
                            : (_) {},
                      ),
                    ),
                    SizedBox(height: AppTokens.settingsTileGap.h),
                    _disableableToggle(
                      enabled: pushEnabled,
                      child: AppToggleTile(
                        title: 'Reminders',
                        value: prefs.reminders && pushEnabled,
                        onChanged: pushEnabled
                            ? (v) => ref
                                .read(notificationPreferencesProvider.notifier)
                                .toggle('reminders', v)
                            : (_) {},
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // — Other —
                    _SectionHeader(title: 'Other'),
                    SizedBox(height: 8.h),
                    _disableableToggle(
                      enabled: pushEnabled,
                      child: AppToggleTile(
                        title: 'App Updates & Events',
                        value: prefs.appUpdatesAndEvents && pushEnabled,
                        onChanged: pushEnabled
                            ? (v) => ref
                                .read(notificationPreferencesProvider.notifier)
                                .toggle('appUpdatesAndEvents', v)
                            : (_) {},
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _disableableToggle({
    required bool enabled,
    required Widget child,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: child,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: AppTokens.fontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8E8E93),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
