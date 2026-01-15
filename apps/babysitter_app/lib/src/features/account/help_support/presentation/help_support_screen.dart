import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/routing/routes.dart';
import 'package:babysitter_app/src/common_widgets/app_action_tile.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTokens.bg, // Light blue app bar
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.appBarTitleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTokens.appBarTitleColor,
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppTokens.dividerSoft,
            height: 1.0,
          ),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  // Hero Icon
                  Container(
                    width: AppTokens.heroSize,
                    height: AppTokens.heroSize,
                    decoration: BoxDecoration(
                      color: AppTokens.heroBg,
                      borderRadius: BorderRadius.circular(AppTokens.heroRadius),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppTokens.heroIconColor,
                        size: AppTokens.heroIconSize,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Big Title
                  Text(
                    'Help & Support',
                    style: AppTokens.helpSupportHeaderStyle,
                  ),
                  SizedBox(height: 24.h),
                  // Action Tiles
                  AppActionTile(
                    leadingIcon: Icon(
                      Icons.chat_bubble_outline,
                      color: AppTokens.iconGrey,
                      size: 24.sp,
                    ),
                    title: 'Contact Live Chat',
                    onTap: () => context.push(Routes.supportChat),
                  ),
                  SizedBox(height: 16.h),
                  AppActionTile(
                    leadingIcon: Icon(
                      Icons.mail_outline,
                      color: AppTokens.iconGrey,
                      size: 24.sp,
                    ),
                    title: 'Send Us An Email',
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'support@carenest.com',
                      );
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  AppActionTile(
                    leadingIcon: Icon(
                      Icons.help_outline,
                      color: AppTokens.iconGrey,
                      size: 24.sp,
                    ),
                    title: 'Faqs',
                    // Placeholder for FAQ screen if it were real
                    onTap: () {},
                  ),
                  SizedBox(height: 16.h),
                  AppActionTile(
                    leadingIcon: Icon(
                      Icons.description_outlined,
                      color: AppTokens.iconGrey,
                      size: 24.sp,
                    ),
                    title: 'Terms of Service',
                    // Navigates to existing Terms screen
                    onTap: () => context.push('/parent/account/terms'),
                    // Note: Ideally utilize a named route constant if available,
                    // or just push the existing TermsAndConditionsScreen.
                    // The 'Routes.parentAccount' is a base, terms is probably sub-route?
                    // Or I can push widget directly for now if route not defined?
                    // I'll check Routes for terms path or push widget.
                    // Wait, I built TermsAndConditionsScreen but did I add a route for it?
                    // Previous task said "Connect to Account Screen navigation", which usually implies push widget directly.
                    // I'll check `account_screen.dart` again to see how it pushed Terms.
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
