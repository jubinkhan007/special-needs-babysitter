import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/common_widgets/app_toggle_tile.dart';
import 'manage_notifications_controller.dart';

/// Manage Notifications screen
/// Displays toggles for different notification preferences
class ManageNotificationsScreen extends StatefulWidget {
  const ManageNotificationsScreen({super.key});

  @override
  State<ManageNotificationsScreen> createState() =>
      _ManageNotificationsScreenState();
}

class _ManageNotificationsScreenState extends State<ManageNotificationsScreen> {
  late final ManageNotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ManageNotificationsController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.settingsBg,
      appBar: AppBar(
        backgroundColor: AppTokens.settingsBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
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
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.settingsHPad.w,
            ),
            child: Column(
              children: [
                SizedBox(height: AppTokens.settingsTopPad.h),

                // Push Notifications
                AppToggleTile(
                  title: 'Push Notifications',
                  value: _controller.pushNotifications,
                  onChanged: _controller.togglePushNotifications,
                ),

                SizedBox(height: AppTokens.settingsTileGap.h),

                // Job Updates
                AppToggleTile(
                  title: 'Job Updates',
                  value: _controller.jobUpdates,
                  onChanged: _controller.toggleJobUpdates,
                ),

                SizedBox(height: AppTokens.settingsTileGap.h),

                // Messages
                AppToggleTile(
                  title: 'Messages',
                  value: _controller.messages,
                  onChanged: _controller.toggleMessages,
                ),

                SizedBox(height: AppTokens.settingsTileGap.h),

                // Reminders
                AppToggleTile(
                  title: 'Reminders',
                  value: _controller.reminders,
                  onChanged: _controller.toggleReminders,
                ),

                SizedBox(height: AppTokens.settingsTileGap.h),

                // App Updates & Events
                AppToggleTile(
                  title: 'App Updates & Events',
                  value: _controller.appUpdatesEvents,
                  onChanged: _controller.toggleAppUpdates,
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
