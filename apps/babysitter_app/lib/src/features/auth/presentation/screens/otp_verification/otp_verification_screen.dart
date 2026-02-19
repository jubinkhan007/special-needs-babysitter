import 'package:flutter/material.dart';

import 'package:core/core.dart';

import '../../widgets/otp_input.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../widgets/step_indicator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';
import '../../../../../routing/app_router.dart'; // For signUpInProgressProvider
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// OTP Verification Screen
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final VoidCallback onVerified;
  final VoidCallback onBack;
  final String verificationType; // 'phone' or 'email'
  final String destination; // Phone number or email address
  final String? userId; // Added userId

  const OtpVerificationScreen({
    super.key,
    required this.onVerified,
    required this.onBack,
    required this.verificationType,
    required this.destination,
    this.userId,
    this.role, // Added role
  });

  final String? role;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otp = '';
  bool _isLoading = false;

  void _verifyCode() async {
    if (_otp.length < 6) {
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Call AuthNotifier to verify OTP
    // Assuming verificationType 'phone' means we are verifying the phone number
    // passed in widget.destination.
    // Note: The UI says "Verify Your Account", so this is likely account/phone verification.

    final notifier = ref.read(authNotifierProvider.notifier);

    // We need to know if we are verifying email or phone.
    // The screen has `verificationType` ('phone' or 'email') and `destination`.
    String? phone;
    String? email;

    if (widget.verificationType == 'phone') {
      phone = widget.destination;
    } else {
      email = widget.destination;
    }

    // IMPORTANT: Set sign-up flag BEFORE verifyOtp to tell router to redirect to profileSetup
    // This beats the race condition where router refresh happens before our navigation
    // Using global variable instead of StateProvider for reliability
    isSignUpInProgress = true;

    // Store callback reference
    final shouldNavigate = widget.onVerified;

    // Convert role string to UserRole enum if present
    UserRole? userRole;
    debugPrint('DEBUG OtpVerificationScreen: widget.role=${widget.role}');
    if (widget.role != null) {
      if (widget.role!.toLowerCase() == 'sitter') {
        userRole = UserRole.sitter;
      } else {
        userRole = UserRole.parent;
      }
    }
    debugPrint('DEBUG OtpVerificationScreen: Calculated userRole=$userRole');

    await notifier.verifyOtp(
      code: _otp,
      phone: phone,
      email: email,
      userId: widget.userId,
      role: userRole,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Check if successful
    final state = ref.read(authNotifierProvider);
    if (state.hasValue && state.value != null) {
      // Use WidgetsBinding to navigate in the same frame before router refresh
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          shouldNavigate();
        }
      });
    } else if (state.hasError) {
      AppToast.show(context, 
        SnackBar(
          content: Text('Verification failed: ${state.error}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _resendCode() {
    AppToast.show(context, 
      SnackBar(
        content: Text('Code resent to your ${widget.verificationType}'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = widget.verificationType == 'email';

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'We\'ve sent a verification code to your ${isEmail ? 'email' : 'phone'}.\nPlease complete the following to proceed.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary.withOpacity(0.6),
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
                          color: AppColors.textPrimary.withOpacity(0.5),
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
                            color: AppColors.textPrimary,
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
