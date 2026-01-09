import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import 'steps/step0_intro.dart';
import 'steps/step1_family_intro.dart';
import 'steps/step2_spouse.dart';
import 'steps/step3_emergency_insurance.dart';
import 'steps/step4_review.dart';

import 'steps/step7_complete.dart';

/// Parent Profile Setup Flow Controller
/// Manages navigation through the 7-step profile setup wizard
class ProfileSetupFlow extends ConsumerStatefulWidget {
  const ProfileSetupFlow({super.key});

  @override
  ConsumerState<ProfileSetupFlow> createState() => _ProfileSetupFlowState();
}

class _ProfileSetupFlowState extends ConsumerState<ProfileSetupFlow> {
  int _currentStep = 0; // 0 = intro, 1-6 = steps, 7 = complete
  final Map<String, dynamic> _profileData = {};

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      // Go back to wherever user came from
      context.pop();
    }
  }

  void _onComplete() {
    // TODO: Final save confirm? Or just animation step
    _goToStep(7);
  }

  void _onFinish() {
    // Navigate to main app
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return Step0Intro(
          onNext: () => _goToStep(1),
        );
      case 1:
        return Step1FamilyIntro(
          onNext: () => _goToStep(2),
          onBack: _goBack,
        );
      case 2:
        return Step2Children(
          profileData: _profileData,
          onNext: () => _goToStep(3),
          onBack: _goBack,
        );
      case 3:
        return Step3EmergencyAndInsurance(
          profileData: _profileData,
          onNext: () => _goToStep(4),
          onBack: _goBack,
        );
      case 4:
        return Step4Review(
          profileData: _profileData,
          onFinish: _onComplete,
          onBack: () => _goToStep(3),
        );
      case 7:
        return Step7Complete(
          onFinish: _onFinish,
        );
      default:
        return Step0Intro(
          onNext: () => _goToStep(1),
        );
    }
  }
}
