import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import 'package:babysitter_app/common/theme/auth_theme.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:auth/auth.dart';
import 'reset_password_screen.dart';

/// Change Password / Reset Your Password screen
/// Matches Figma design pixel-for-pixel
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Validates email and returns error if invalid
  String? _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _sendResetLink() async {
    _emailError = _validateEmail();
    if (_emailError != null) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    try {
      final dio = ref.read(authDioProvider);
      await dio.post(
        '/auth/forgot-password',
        data: {'email': _emailController.text.trim()},
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate to reset password screen on success
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      String errorMessage = 'Failed to send reset link. Please try again.';
      if (e.toString().contains('404')) {
        errorMessage = 'Email address not found. Please check and try again.';
      }

      AppToast.show(
        context,
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
    }
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _sendResetLink(),
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
                    errorText: _emailError,
                  ),
                ),

                SizedBox(height: 24.h),

                // Send Reset Link Button
                PrimaryActionButton(
                  label: 'Send Reset Link',
                  isLoading: _isLoading,
                  onPressed: _sendResetLink,
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
