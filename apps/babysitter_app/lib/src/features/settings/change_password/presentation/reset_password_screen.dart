import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import 'package:babysitter_app/common/theme/auth_theme.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'reset_password_controller.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Reset Password Screen (Step 2)
/// User enters new password and confirmation
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final ResetPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ResetPasswordController();
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

  Future<void> _onSavePassword() async {
    final success = await _controller.savePassword();
    if (success && mounted) {
      AppToast.show(context, 
        const SnackBar(content: Text('Password updated successfully!')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
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

                // Subtitle
                Text(
                  'Please enter your new password',
                  style: TextStyle(
                    fontFamily: AppTokens.fontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTokens.textSecondary,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Password field
                TextFormField(
                  controller: _controller.passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AuthTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password*',
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
                      borderSide: const BorderSide(color: AppTokens.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppTokens.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppTokens.primaryBlue,
                        width: 1.5,
                      ),
                    ),
                    errorText: _controller.passwordError,
                  ),
                ),

                SizedBox(height: 16.h),

                // Confirm Password field
                TextFormField(
                  controller: _controller.confirmPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSavePassword(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AuthTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password*',
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
                      borderSide: const BorderSide(color: AppTokens.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppTokens.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppTokens.primaryBlue,
                        width: 1.5,
                      ),
                    ),
                    errorText: _controller.confirmPasswordError,
                  ),
                ),

                SizedBox(height: 24.h),

                // Save Password Button
                PrimaryActionButton(
                  label: 'Save Password',
                  isLoading: _controller.isLoading,
                  onPressed: _onSavePassword,
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
