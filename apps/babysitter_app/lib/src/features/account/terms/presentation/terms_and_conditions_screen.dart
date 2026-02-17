import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/common_widgets/legal/legal_document_section.dart';
import '../data/terms_content.dart';

/// Terms and Conditions screen
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Need Help?'),
        content:
            const Text('Contact support at support@specialneedssitters.com'),
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
      backgroundColor: Colors.white,
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
          'Terms & Conditions',
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
              onTap: () => _showHelpDialog(context),
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.screenHorizontalPadding.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  ...termsContent.map(
                    (section) => LegalDocumentSection.fromModel(section),
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
