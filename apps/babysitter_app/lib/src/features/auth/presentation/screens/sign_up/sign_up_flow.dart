import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:domain/domain.dart';

import '../../../../../routing/routes.dart';
import 'steps/step1_account_info.dart';
import 'steps/step2_password_security.dart';
import '../otp_verification/otp_verification_screen.dart';

/// Multi-step sign up flow controller (3 steps per Figma)
/// Step 1: Account Info
/// Step 2: Password + Security Question (combined)
/// Step 3: Phone OTP Verification
class SignUpFlow extends ConsumerStatefulWidget {
  const SignUpFlow({super.key});

  @override
  ConsumerState<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends ConsumerState<SignUpFlow> {
  int _currentStep = 1;
  final Map<String, String> _formData = {'role': 'parent'};

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

  void _onRegistrationSuccess(RegisteredUser user) {
    _goToStep(3); // Go to OTP verification
  }

  void _onOtpVerified() {
    // After OTP verification, go to profile setup for parents
    final role = _formData['role'];
    if (role == 'parent') {
      context.go(Routes.profileSetup);
    } else {
      // Sitters go to their home (or sitter profile setup later)
      context.go(Routes.sitterHome);
    }
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
        return Step2PasswordSecurity(
          formData: _formData,
          onBack: () => _goToStep(1),
          onSuccess: _onRegistrationSuccess,
        );
      case 3:
        return OtpVerificationScreen(
          verificationType: 'phone',
          destination: _formData['phone'] ?? '',
          onBack: () => _goToStep(2),
          onVerified: _onOtpVerified,
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
