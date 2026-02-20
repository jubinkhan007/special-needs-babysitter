import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';

import '../../routing/routes.dart';
import 'presentation/widgets/auth_input_field.dart';
import '../../../common/widgets/primary_action_button.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Forgot Password screen - Pixel-perfect matching Figma design
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty && phone.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(
          content: Text('Please enter email or phone number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = ref.read(authDioProvider);
      await dio.post(
        '/auth/forgot-password',
        data: {'email': email.isNotEmpty ? email : phone},
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Determine which method was used and show appropriate dialog
      if (email.isNotEmpty) {
        _showConfirmationDialog(
          title: 'Email Sent',
          message:
              'We have sent a confirmation link on your email. Please click on the link to update your password.',
        );
      } else {
        _showConfirmationDialog(
          title: 'SMS Sent',
          message:
              'We have sent a confirmation link on your phone. Please click on the link to update your password.',
        );
      }
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
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => _ResetConfirmationDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Hero image at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.42,
            child: ClipPath(
              clipper: _BottomCurveClipper(),
              child: Image.asset(
                'assets/onboarding_4.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(
                      Icons.family_restroom,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom card with form
          Positioned(
            top: screenHeight * 0.36,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Enter your email or phone number to reset your password. We will send you a reset link using whichever method you provide.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Email field
                      AuthInputField(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // "or" text
                      const Center(
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone Number field
                      AuthInputField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 28),

                      // Send Reset Link button
                      PrimaryActionButton(
                        label: 'Send Reset Link',
                        onPressed: _isLoading ? null : _sendResetLink,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 20),

                      // Don't have access link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Navigate to alternate recovery
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 2),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF1A1A1A), width: 1.2),
                              ),
                            ),
                            child: const Text(
                              "Don't have access to your phone or Email?",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF1A1A1A)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirmation dialog matching Figma design
class _ResetConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const _ResetConfirmationDialog({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button (top right)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A4A4A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Test button to navigate to Update Password
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(Routes.updatePassword);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Test: Go to Update Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom clipper for curved bottom edge on hero image
class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
