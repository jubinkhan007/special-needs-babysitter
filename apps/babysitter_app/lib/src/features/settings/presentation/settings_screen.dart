import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_tokens.dart';
import '../domain/settings_item.dart';
import 'widgets/settings_item_tile.dart';
import 'dialogs/show_delete_account_dialog.dart';
import '../change_password/presentation/change_password_screen.dart';
import '../manage_notifications/presentation/manage_notifications_screen.dart';
import '../privacy_settings/presentation/privacy_settings_screen.dart';

/// The Settings screen displaying configurable options.
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onChangePassword;
  final VoidCallback? onManageNotifications;
  final VoidCallback? onPrivacySettings;
  final VoidCallback? onDeleteAccount;

  const SettingsScreen({
    super.key,
    this.onChangePassword,
    this.onManageNotifications,
    this.onPrivacySettings,
    this.onDeleteAccount,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLocationEnabled = true;

  final List<SettingsItem> _items = const [
    SettingsItem(
      id: 'change_password',
      title: 'Change Password',
      icon: Icons.lock_outline,
    ),
    SettingsItem(
      id: 'manage_notifications',
      title: 'Manage Notifications',
      icon: Icons.notifications_outlined,
    ),
    SettingsItem(
      id: 'privacy_settings',
      title: 'Privacy Settings',
      icon: Icons.security_outlined,
    ),
    SettingsItem(
      id: 'enable_location',
      title: 'Enable Location',
      icon: Icons.location_on_outlined,
      type: SettingsItemType.toggle,
    ),
    SettingsItem(
      id: 'delete_account',
      title: 'Delete Account',
      icon: Icons.delete_outline,
    ),
  ];

  Future<void> _handleItemTap(SettingsItem item) async {
    switch (item.id) {
      case 'change_password':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ChangePasswordScreen(),
          ),
        );
        break;
      case 'manage_notifications':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ManageNotificationsScreen(),
          ),
        );
        break;
      case 'privacy_settings':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PrivacySettingsScreen(),
          ),
        );
        break;
      case 'delete_account':
        // Show confirmation dialog
        final confirmed = await showDeleteAccountDialog(context);
        if (confirmed == true) {
          widget.onDeleteAccount?.call();
        }
        break;
    }
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
          'Settings',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
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
      body: MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.0,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                left: AppTokens.settingsHPad.w,
                right: AppTokens.settingsHPad.w,
                top: AppTokens.settingsTopPad.h,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ..._items.map((item) => Padding(
                        padding: EdgeInsets.only(
                            bottom: AppTokens.settingsTileGap.h),
                        child: SettingsItemTile(
                          icon: item.icon,
                          title: item.title,
                          onTap: item.type == SettingsItemType.navigation
                              ? () => _handleItemTap(item)
                              : null,
                          trailing: item.type == SettingsItemType.toggle
                              ? SettingsSwitch(
                                  value: _isLocationEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _isLocationEnabled = value;
                                    });
                                  },
                                )
                              : null,
                        ),
                      )),
                  SizedBox(height: 32.h), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
