import 'package:flutter/material.dart';
import '../sitter_account_ui_constants.dart';

class SitterAccountMenuList extends StatelessWidget {
  final VoidCallback onTapRatingsReviews;
  final VoidCallback onTapWallet;
  final VoidCallback onTapReferralBonuses;
  final VoidCallback onTapSettings;
  final VoidCallback onTapAbout;
  final VoidCallback onTapTerms;
  final VoidCallback onTapHelp;
  final VoidCallback onTapSignOut;

  const SitterAccountMenuList({
    super.key,
    required this.onTapRatingsReviews,
    required this.onTapWallet,
    required this.onTapReferralBonuses,
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
          icon: Icons.star_border_outlined,
          label: 'Rating & Reviews',
          subtitle: 'Check all your reviews',
          onTap: onTapRatingsReviews,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'My Wallet',
          onTap: onTapWallet,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.card_giftcard_outlined,
          label: 'Referral & Bonuses',
          onTap: onTapReferralBonuses,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: onTapSettings,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.info_outline,
          label: 'About Special Needs Sitters App',
          onTap: onTapAbout,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Icons.description_outlined,
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
          icon: Icons.logout_outlined,
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
        decoration: SitterAccountUI.cardDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: SitterAccountUI.textGray),
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
                      color: SitterAccountUI.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: SitterAccountUI.textGray,
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
