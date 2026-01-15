import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'widgets/highlight_item.dart';

/// About Special Needs Sitters screen
/// Static content screen with app information
class AboutSpecialNeedsSittersScreen extends StatelessWidget {
  const AboutSpecialNeedsSittersScreen({super.key});

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
          icon: Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'About',
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.screenHorizontalPadding.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Welcome Title (2 lines)
                  Text(
                    'Welcome to Special Needs\nSitters',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamily,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Intro Paragraph
                  Text(
                    'At Special Needs Sitters, we connect families with trusted, verified babysitters who provide safe, compassionate care—whether you need occasional help or specialized support for children with unique needs. Our mission is to create a secure and nurturing space for your child, giving you peace of mind.',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamily,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTokens.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Key Highlights Header
                  Text(
                    'Key Highlights',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamily,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Highlight Items
                  const HighlightItem(
                    titleBold: 'Trusted Caregivers:',
                    description:
                        'All sitters are background-checked and verified.',
                  ),

                  const HighlightItem(
                    titleBold: 'Seamless Communication:',
                    description:
                        'Chat, call, and track your sitter directly within the app.',
                  ),

                  const HighlightItem(
                    titleBold: 'Secure Payments:',
                    description:
                        'Easy and secure payment processing with complete transparency.',
                  ),

                  const HighlightItem(
                    titleBold: 'Personalized Support:',
                    description:
                        'Find sitters with experience in general care or special needs.',
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
