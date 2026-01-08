import 'package:flutter/material.dart';

import '../../../../../../../common/theme/auth_theme.dart';
import '../../widgets/otp_input.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../widgets/step_indicator.dart';

/// OTP Verification Screen
class OtpVerificationScreen extends StatefulWidget {
  final VoidCallback onVerified;
  final VoidCallback onBack;
  final String verificationType; // 'phone' or 'email'
  final String destination; // Phone number or email address

  const OtpVerificationScreen({
    super.key,
    required this.onVerified,
    required this.onBack,
    required this.verificationType,
    required this.destination,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otp = '';
  bool _isLoading = false;

  void _verifyCode() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // TODO: Actually verify the code
    widget.onVerified();
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code resent to your ${widget.verificationType}'),
        backgroundColor: AuthTheme.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = widget.verificationType == 'email';

    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header
                    StepIndicator(
                      currentStep: 1,
                      totalSteps: 1,
                      title: 'Verification',
                      onBack: widget.onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Verify Your Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AuthTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'We\'ve sent a verification code to your ${isEmail ? 'email' : 'phone'}.\nPlease complete the following to proceed.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AuthTheme.textDark.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP Input
                    OtpInput(
                      onCompleted: (otp) => setState(() => _otp = otp),
                      onChanged: (otp) => setState(() => _otp = otp),
                    ),
                    const SizedBox(height: 12),

                    // Helper text
                    Center(
                      child: Text(
                        'Enter the 6-digit code sent to your ${isEmail ? 'email' : 'phone'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AuthTheme.textDark.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Verify button
                    PrimaryActionButton(
                      label: 'Verify Code',
                      onPressed: _isLoading ? null : _verifyCode,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 20),

                    // Resend code
                    Center(
                      child: GestureDetector(
                        onTap: _resendCode,
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: AuthTheme.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
