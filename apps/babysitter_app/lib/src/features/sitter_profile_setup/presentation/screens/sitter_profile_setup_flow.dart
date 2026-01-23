import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../parent_profile_setup/presentation/screens/steps/step0_intro.dart';
import '../providers/sitter_profile_setup_providers.dart';
import 'steps/step1_upload_photo.dart';
import 'steps/step2_bio.dart';
import 'steps/step3_location.dart';
import 'steps/step4_skills.dart';
import 'steps/step5_experience.dart';
import 'steps/step6_certification.dart';
import 'steps/step7_availability.dart';
import 'steps/step8_hourly_rate.dart';
import 'steps/step9_review_profile.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Sitter Profile Setup Flow Controller
/// Manages navigation through the 9-step profile setup wizard for sitters
class SitterProfileSetupFlow extends ConsumerStatefulWidget {
  const SitterProfileSetupFlow({super.key});

  @override
  ConsumerState<SitterProfileSetupFlow> createState() =>
      _SitterProfileSetupFlowState();
}

class _SitterProfileSetupFlowState
    extends ConsumerState<SitterProfileSetupFlow> {
  int _currentStep = 0; // 0=Intro, 1-9=Steps
  bool _isSaving = false;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  /// Saves the current step to the API, then advances to the next step.
  Future<void> _saveAndAdvance(
      int currentStepNumber, int nextStepNumber) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final controller =
          ref.read(sitterProfileSetupControllerProvider.notifier);
      final repository = ref.read(sitterProfileRepositoryProvider);

      print('DEBUG FLOW: Saving step $currentStepNumber before advancing...');
      final success = await controller.saveStep(currentStepNumber, repository);

      if (!mounted) return;

      if (success) {
        print(
            'DEBUG FLOW: Step $currentStepNumber saved successfully, advancing to step $nextStepNumber');
        _goToStep(nextStepNumber);
      } else {
        AppToast.show(context, 
          SnackBar(
              content: Text(
                  'Failed to save step $currentStepNumber. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading overlay if saving
    return Stack(
      children: [
        _buildCurrentStep(),
        if (_isSaving)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Step0Intro(
          onNext: () => _goToStep(1), // Intro doesn't need API save
          isSitter: true,
        );
      case 1:
        return Step1UploadPhoto(
          onNext: () => _saveAndAdvance(1, 2),
          onBack: _goBack,
        );
      case 2:
        return Step2Bio(
          onNext: () => _saveAndAdvance(2, 3),
          onBack: _goBack,
        );
      case 3:
        return Step3Location(
          onNext: () => _saveAndAdvance(3, 4),
          onBack: _goBack,
        );
      case 4:
        return Step4Skills(
          onNext: () => _saveAndAdvance(4, 5),
          onBack: _goBack,
        );
      case 5:
        return Step5Experience(
          onNext: () => _saveAndAdvance(5, 6),
          onBack: _goBack,
        );
      case 6:
        return Step6Certification(
          onNext: () => _saveAndAdvance(6, 7),
          onBack: _goBack,
        );
      case 7:
        return Step7Availability(
          onFinish: () => _saveAndAdvance(7, 8),
          onBack: _goBack,
        );
      case 8:
        return Step8HourlyRate(
          onNext: () => _saveAndAdvance(8, 9),
          onBack: _goBack,
        );
      case 9:
        return Step9ReviewProfile(
          onFinish: _finishSetup,
          onBack: _goBack,
          onEditStep: (step) => _goToStep(step),
        );
      default:
        return Step1UploadPhoto(
          onNext: () => _saveAndAdvance(1, 2),
          onBack: _goBack,
        );
    }
  }

  void _finishSetup() {
    // Navigate to completion / dashboard / review
    if (context.mounted) {
      AppToast.show(context, 
        const SnackBar(content: Text('Profile Setup Completed!')),
      );
    }
  }
}
