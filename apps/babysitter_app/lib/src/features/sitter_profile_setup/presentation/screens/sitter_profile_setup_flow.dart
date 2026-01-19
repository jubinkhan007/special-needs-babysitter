import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../parent_profile_setup/presentation/screens/steps/step0_intro.dart';
import 'steps/step1_upload_photo.dart';
import 'steps/step2_bio.dart';
import 'steps/step3_location.dart';
import 'steps/step4_skills.dart';
import 'steps/step5_experience.dart';
import 'steps/step6_certification.dart';
import 'steps/step7_availability.dart';
import 'steps/step8_hourly_rate.dart';
import 'steps/step9_review_profile.dart';

/// Sitter Profile Setup Flow Controller
/// Manages navigation through the 7-step profile setup wizard for sitters
class SitterProfileSetupFlow extends ConsumerStatefulWidget {
  const SitterProfileSetupFlow({super.key});

  @override
  ConsumerState<SitterProfileSetupFlow> createState() =>
      _SitterProfileSetupFlowState();
}

class _SitterProfileSetupFlowState
    extends ConsumerState<SitterProfileSetupFlow> {
  int _currentStep = 0; // 0=Intro, 1-7=Steps

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      // Go back to wherever user came from (or logout?)
      // Usually profile setup is mandatory after signup, so pop might not be right if
      // there is no "back" history. But GoRouter handles pop.
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return Step0Intro(
          onNext: () => _goToStep(1),
          isSitter: true,
        );
      case 1:
        return Step1UploadPhoto(
          onNext: () => _goToStep(2),
          onBack: _goBack,
        );
      case 2:
        return Step2Bio(
          onNext: () => _goToStep(3),
          onBack: _goBack,
        );
      case 3:
        return Step3Location(
          onNext: () => _goToStep(4),
          onBack: _goBack,
        );
      case 4:
        return Step4Skills(
          onNext: () => _goToStep(5),
          onBack: _goBack,
        );
      case 5:
        return Step5Experience(
          onNext: () => _goToStep(6),
          onBack: _goBack,
        );
      case 6:
        return Step6Certification(
          onNext: () => _goToStep(7),
          onBack: _goBack,
        );
      case 7:
        return Step7Availability(
          onFinish: () => _goToStep(8),
          onBack: _goBack,
        );
      case 8:
        return Step8HourlyRate(
          onNext: () => _goToStep(9),
          onBack: _goBack,
        );
      case 9:
        return Step9ReviewProfile(
          onFinish: _finishSetup,
          onBack: _goBack,
          onEditStep: (step) => _goToStep(step),
        );
      default:
        // Fallback
        return Step1UploadPhoto(
          onNext: () => _goToStep(2),
          onBack: _goBack, // Added onBack
        );
    }
  }

  void _finishSetup() {
    // Navigate to completion / dashboard / review
    // For now, we pop or go to home.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Setup Completed!')),
      );
      // context.go('/home'); // Or whatever the next route is
    }
  }
}
