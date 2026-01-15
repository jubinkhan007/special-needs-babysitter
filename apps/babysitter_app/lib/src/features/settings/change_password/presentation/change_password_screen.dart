import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import 'package:babysitter_app/common/theme/auth_theme.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'change_password_controller.dart';
import 'reset_password_screen.dart';

/// Change Password / Reset Your Password screen
/// Matches Figma design pixel-for-pixel
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final ChangePasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChangePasswordController();
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
      backgroundColor: AppTokens.settingsBg,
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
          'Change Password',
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.screenHorizontalPadding.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),

                // Headline
                Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontFamily: AppTokens.fontFamily,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                    height: 1.2,
                  ),
                ),

                SizedBox(height: 12.h),

                // Description
                Text(
                  "Enter your email address below, and we'll send you instructions to reset your password.",
                  style: TextStyle(
                    fontFamily: AppTokens.fontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTokens.textSecondary,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Email field (without label - just hint inside)
                TextFormField(
                  controller: _controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _controller.sendResetLink(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AuthTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: AuthTheme.textDark.withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppTokens.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppTokens.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppTokens.primaryBlue,
                        width: 1.5,
                      ),
                    ),
                    errorText: _controller.emailError,
                  ),
                ),

                SizedBox(height: 24.h),

                // Send Reset Link Button
                PrimaryActionButton(
                  label: 'Send Reset Link',
                  isLoading: _controller.isLoading,
                  onPressed: () async {
                    await _controller.sendResetLink();
                    if (mounted && _controller.emailError == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ResetPasswordScreen(),
                        ),
                      );
                    }
                  },
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
