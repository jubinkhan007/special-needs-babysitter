import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';
import '../../widgets/multi_select_accordion.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class Step4Skills extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Skills({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step4Skills> createState() => _Step4SkillsState();
}

class _Step4SkillsState extends ConsumerState<Step4Skills> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = AppColors.primary;

  final List<String> _availableCertifications = [
    'CPR Certification',
    'First Aid Certification',
    'Childcare or Babysitting Certification',
    'Special Needs Care Training',
    'Background Check Clearance',
    'Health & Safety Training',
    'Early Childhood Education Courses',
    'Behavioral Management Training',
    'Medication Administration Certification',
    'None At This Time',
  ];

  final List<String> _availableSkills = [
    'Patience & empathy',
    'Non-verbal communication skills',
    'Behavior management',
    'Crisis de-escalation',
    'Routine & structure planning',
    'Sensory awareness',
    'Toileting & hygiene support',
    'Social-emotional coaching',
    'Flexible thinking & adaptability',
    'Medication Administration',
    'Mobility & Transfer Support',
    'Communication Support',
    'Homework/Tutoring Support',
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final controller = ref.read(sitterProfileSetupControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 4,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 4, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.bookmark_border_rounded,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Skills & Certifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    'Enter Your Skills & Certifications Into This Screen In Order To Create Your New Account.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textDark.withOpacity(0.7),
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Accordion 1: Certifications
                  MultiSelectAccordion(
                    title: 'Select Certifications',
                    options: _availableCertifications,
                    selectedValues: state.certifications,
                    onChanged: (values) =>
                        controller.updateCertifications(values),
                    onOtherTap: () {
                      AppToast.show(context, const SnackBar(
                          content: Text('Add Other Certification tapped')));
                    },
                  ),
                  const SizedBox(height: 16),

                  // Accordion 2: Skills
                  MultiSelectAccordion(
                    title: 'Select Skills',
                    options: _availableSkills,
                    selectedValues: state.skills,
                    onChanged: (values) => controller.updateSkills(values),
                    onOtherTap: () {
                      AppToast.show(context, const SnackBar(
                          content: Text('Add Other Skill tapped')));
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: () {
              widget.onNext();
            },
          ),
        ),
      ),
    );
  }
}
