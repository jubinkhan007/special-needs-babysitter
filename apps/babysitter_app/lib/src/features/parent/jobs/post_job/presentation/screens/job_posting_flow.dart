import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../routing/routes.dart';
import 'select_child_step1_view.dart';
import 'job_post_step_2_job_details_screen.dart';
import 'job_post_step_3_location_screen.dart';
import 'job_post_step_4_details_pay_screen.dart';
import 'job_post_step_5_review_screen.dart';
import '../providers/job_post_providers.dart';
import '../widgets/job_post_success_dialog.dart';

/// Job Posting Flow Controller
/// Manages navigation through the 4-step job posting wizard
class JobPostingFlow extends ConsumerStatefulWidget {
  const JobPostingFlow({super.key});

  @override
  ConsumerState<JobPostingFlow> createState() => _JobPostingFlowState();
}

class _JobPostingFlowState extends ConsumerState<JobPostingFlow> {
  int _currentStep =
      0; // 0 = Step 1 (Select Child), 1 = Step 2 (Job Details), etc.

  @override
  void initState() {
    super.initState();
    // Load local draft if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobPostControllerProvider.notifier).loadLocalDraft();
    });
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      // Go back to where user came from
      context.pop();
    }
  }

  void _onComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobPostSuccessDialog(
        onInviteSitters: () {
          ref.read(jobPostControllerProvider.notifier).resetState();
          Navigator.pop(context);
          context.go(Routes.parentHome);
        },
        onGoToHome: () {
          ref.read(jobPostControllerProvider.notifier).resetState();
          Navigator.pop(context);
          context.go(Routes.parentHome);
        },
        onEditJob: () {
          Navigator.pop(context);
          // Don't reset state, so they can see/edit the data on Step 5
        },
        onClose: () {
          ref.read(jobPostControllerProvider.notifier).resetState();
          Navigator.pop(context);
          context.go(Routes.parentHome);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return SelectChildStep1View(
          onNext: () => _goToStep(1),
          onBack: _goBack,
        );
      case 1:
        return JobPostStep2JobDetailsScreen(
          onNext: () => _goToStep(2),
          onBack: _goBack,
        );
      case 2:
        return JobPostStep3LocationScreen(
          onNext: () => _goToStep(3),
          onBack: _goBack,
        );
      case 3:
        return JobPostStep4DetailsPayScreen(
          onComplete: () => _goToStep(4),
          onBack: _goBack,
        );
      case 4:
        return JobPostStep5ReviewScreen(
          onSubmit: _onComplete,
          onBack: _goBack,
        );
      default:
        return SelectChildStep1View(
          onNext: () => _goToStep(1),
          onBack: _goBack,
        );
    }
  }
}
