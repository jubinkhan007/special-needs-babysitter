import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:babysitter_app/src/features/sitter/account/presentation/sitter_account_ui_constants.dart';
import 'package:babysitter_app/src/routing/routes.dart';

class SitterSettingsScreen extends ConsumerStatefulWidget {
  const SitterSettingsScreen({super.key});

  @override
  ConsumerState<SitterSettingsScreen> createState() =>
      _SitterSettingsScreenState();
}

class _SitterSettingsScreenState extends ConsumerState<SitterSettingsScreen> {
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SitterAccountUI.backgroundBlue,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: SitterAccountUI.textGray,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: SitterAccountUI.backgroundBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SitterAccountUI.textGray),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterAccount);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: SitterAccountUI.textGray),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: SitterAccountUI.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Settings',
              style: SitterAccountUI.titleStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            _SettingsItem(
              icon: Icons.shield_outlined,
              label: 'Change Password',
              onTap: () {
                // Navigate to change password
                context.push(Routes.updatePassword);
              },
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.notifications_none_outlined,
              label: 'Manage Notifications',
              onTap: () {
                // TODO: Notifications settings
              },
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Settings',
              onTap: () {
                // TODO: Privacy settings
              },
            ),
            const SizedBox(height: 12),
            Container(
              decoration: SitterAccountUI.cardDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.explore_outlined,
                      size: 24, color: SitterAccountUI.textGray),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Enable Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SitterAccountUI.textDark,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _locationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _locationEnabled = value;
                        });
                      },
                      activeThumbColor: SitterAccountUI.accentBlue,
                      activeTrackColor:
                          SitterAccountUI.accentBlue.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.delete_forever_outlined,
              label: 'Delete Account',
              onTap: () {
                // TODO: Delete account flow
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: SitterAccountUI.cardDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: SitterAccountUI.textGray),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: SitterAccountUI.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
