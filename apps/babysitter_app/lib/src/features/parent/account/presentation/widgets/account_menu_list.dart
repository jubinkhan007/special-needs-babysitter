import 'package:flutter/material.dart';
import '../account_ui_constants.dart';

class AccountMenuList extends StatelessWidget {
  final VoidCallback onTapPayment;
  final VoidCallback onTapSettings;
  final VoidCallback onTapAbout;
  final VoidCallback onTapTerms;
  final VoidCallback onTapHelp;
  final VoidCallback onTapSignOut;

  const AccountMenuList({
    super.key,
    required this.onTapPayment,
    required this.onTapSettings,
    required this.onTapAbout,
    required this.onTapTerms,
    required this.onTapHelp,
    required this.onTapSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.payment_outlined, // Try to find close match
          label: 'Payment',
          subtitle: 'Manage your payment methods',
          onTap: onTapPayment,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: onTapSettings,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.description_outlined,
          label: 'About Special Needs\nSitters',
          onTap: onTapAbout,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.receipt_long_outlined,
          label: 'Terms & Conditions',
          onTap: onTapTerms,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.headset_mic_outlined,
          label: 'Help & Support',
          onTap: onTapHelp,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.logout_outlined, // Or exit_to_app
          label: 'Sign Out',
          onTap: onTapSignOut,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AccountUI.cardDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AccountUI.textGray),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AccountUI.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AccountUI.textGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
