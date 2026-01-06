import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

import '../../../routing/routes.dart';
import 'step1_account_info.dart';
import 'step3_password.dart';
import 'otp_verification_screen.dart';

/// Multi-step sign up flow controller (3 steps now)
/// Step 1: Account Info
/// Step 2: Password & Security
/// Step 3: Phone OTP Verification
class SignUpFlow extends ConsumerStatefulWidget {
  const SignUpFlow({super.key});

  @override
  ConsumerState<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends ConsumerState<SignUpFlow> {
  int _currentStep = 1;
  final Map<String, String> _formData = {};

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.go(Routes.onboarding);
    }
  }

  Future<void> _completeSignUp() async {
    // Create account using auth provider
    await ref.read(authNotifierProvider.notifier).signUp(
          email: _formData['email'] ?? '',
          password: _formData['password'] ?? '',
          firstName: _formData['firstName'] ?? '',
          lastName: _formData['lastName'] ?? '',
          role: UserRole.parent, // Default to parent, can be changed
        );

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    // Navigation handled by router redirect on successful auth
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 1:
        return Step1AccountInfo(
          formData: _formData,
          onBack: _goBack,
          onNext: () => _goToStep(2),
        );
      case 2:
        return Step3Password(
          formData: _formData,
          onBack: () => _goToStep(1),
          onNext: () => _goToStep(3), // Go directly to OTP
        );
      case 3:
        // Phone OTP verification only (no email option)
        return OtpVerificationScreen(
          verificationType: 'phone',
          destination: _formData['phone'] ?? '',
          onBack: () => _goToStep(2),
          onVerified: _completeSignUp,
        );
      default:
        return Step1AccountInfo(
          formData: _formData,
          onBack: _goBack,
          onNext: () => _goToStep(2),
        );
    }
  }
}
