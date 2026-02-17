import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_tokens.dart';
import '../domain/account_menu_item.dart';
import 'widgets/account_profile_card.dart';
import 'widgets/account_stat_cards_row.dart';
import 'widgets/account_menu_tile.dart';
import '../about/presentation/about_special_needs_sitters_screen.dart';

/// The Account tab screen displaying user profile, stats, and menu options.
class AccountScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onBookingHistoryTap;
  final VoidCallback? onSavedSittersTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onSignOutTap;

  const AccountScreen({
    super.key,
    this.onProfileTap,
    this.onBookingHistoryTap,
    this.onSavedSittersTap,
    this.onSettingsTap,
    this.onSignOutTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      const AccountMenuItem(
        icon: Icons.credit_card_outlined,
        title: 'Payment',
      ),
      AccountMenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: onSettingsTap,
      ),
      AccountMenuItem(
        icon: Icons.description_outlined,
        title: 'About Special Needs Sitters',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AboutSpecialNeedsSittersScreen(),
          ),
        ),
      ),
      const AccountMenuItem(
        icon: Icons.article_outlined,
        title: 'Terms & Conditions',
      ),
      const AccountMenuItem(
        icon: Icons.headset_mic_outlined,
        title: 'Help & Support',
      ),
      AccountMenuItem(
        icon: Icons.logout_outlined,
        title: 'Sign Out',
        onTap: onSignOutTap,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTokens.accountBg,
      appBar: AppBar(
        backgroundColor: AppTokens.accountBg,
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
          'Account',
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
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.accountScreenHPad.w,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 16.h),

                  // Profile Card
                  AccountProfileCard(
                    name: 'Christie',
                    email: 'christie29@gmail.com',
                    profileProgress: 0.6,
                    onViewProfile: onProfileTap,
                  ),

                  SizedBox(height: AppTokens.accountSectionGap.h),

                  // Stat Cards Row
                  AccountStatCardsRow(
                    bookingHistoryCount: 4,
                    savedSittersCount: 4,
                    onBookingHistoryTap: onBookingHistoryTap,
                    onSavedSittersTap: onSavedSittersTap,
                  ),

                  SizedBox(height: AppTokens.accountSectionGap.h),

                  // Menu Items
                  ...menuItems.map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AccountMenuTile(
                          icon: item.icon,
                          title: item.title,
                          onTap: item.onTap,
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
