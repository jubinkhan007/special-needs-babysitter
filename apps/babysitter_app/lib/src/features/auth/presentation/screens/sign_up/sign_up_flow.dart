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
  final String initialRole;

  const SignUpFlow({
    super.key,
    this.initialRole = 'parent',
  });

  @override
  ConsumerState<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends ConsumerState<SignUpFlow> {
  int _currentStep = 1;
  late final Map<String, String> _formData;
  String? _userId; // Added variable to store userId

  @override
  void initState() {
    super.initState();
    print(
        'DEBUG SignUpFlow: Initialized with initialRole=${widget.initialRole}');
    _formData = {'role': widget.initialRole};
  }

  @override
  void didUpdateWidget(SignUpFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRole != widget.initialRole) {
      print('DEBUG SignUpFlow: didUpdateWidget newRole=${widget.initialRole}');
      setState(() {
        _formData['role'] = widget.initialRole;
      });
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      final params = <String, String>{};
      if (from != null) {
        params['from'] = from;
      }
      context.go(Uri(path: Routes.onboarding, queryParameters: params).toString());
    }
  }

  void _onRegistrationSuccess(RegisteredUser user) {
    setState(() => _userId = user.id); // Capture userId
    _goToStep(3); // Go to OTP verification
  }

  void _onOtpVerified() {
    // After OTP verification, go to profile setup for parents
    // After OTP verification, go to profile setup for both parents and sitters
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    final params = <String, String>{};
    if (from != null) {
      params['from'] = from;
    }
    context.go(Uri(path: Routes.profileSetup, queryParameters: params).toString());
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
          userId: _userId, // Pass userId
          role: _formData['role'], // Pass role
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
