import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/common_widgets/privacy_radio_section.dart';
import 'privacy_settings_controller.dart';

/// Privacy Settings screen
/// Displays 4 privacy sections with Yes/No radio options
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  late final PrivacySettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PrivacySettingsController();
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Help'),
        content: const Text(
            'These settings control how your data is used within the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
          'Privacy Settings',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: AppTokens.appBarTitleColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: _showHelpDialog,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTokens.iconGrey,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 16.sp,
                    color: AppTokens.iconGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.screenHorizontalPadding.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Personal Data intelligence
                  PrivacyRadioSection(
                    title: 'Personal Data intelligence',
                    selected: _controller.personalDataIntelligence,
                    onChanged: _controller.setPersonalDataIntelligence,
                  ),

                  SizedBox(height: 24.h),

                  // Data Sharing Updates for Location
                  PrivacyRadioSection(
                    title: 'Data Sharing Updates for Location',
                    selected: _controller.locationSharingUpdates,
                    onChanged: _controller.setLocationSharingUpdates,
                  ),

                  SizedBox(height: 24.h),

                  // Account Control
                  PrivacyRadioSection(
                    title: 'Account Control',
                    selected: _controller.accountControl,
                    onChanged: _controller.setAccountControl,
                  ),

                  SizedBox(height: 24.h),

                  // Usage and diagnostics
                  PrivacyRadioSection(
                    title: 'Usage and diagnostics',
                    selected: _controller.usageDiagnostics,
                    onChanged: _controller.setUsageDiagnostics,
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
