import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/theme/auth_theme.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../../widgets/step_indicator.dart';
import '../../../widgets/auth_input_field.dart';
import '../../../controllers/sign_up_controller.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Step 2: Security Question - Loads questions from API
class Step2SecurityQuestion extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, String> formData;

  const Step2SecurityQuestion({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.formData,
  });

  @override
  ConsumerState<Step2SecurityQuestion> createState() =>
      _Step2SecurityQuestionState();
}

class _Step2SecurityQuestionState extends ConsumerState<Step2SecurityQuestion> {
  late final TextEditingController _answerController;
  String? _selectedQuestion;

  @override
  void initState() {
    super.initState();
    _answerController =
        TextEditingController(text: widget.formData['securityAnswer']);
    _selectedQuestion = widget.formData['securityQuestion'];

    // Load security questions on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signUpControllerProvider.notifier).loadSecurityQuestions();
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (_selectedQuestion == null || _selectedQuestion!.isEmpty) {
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please select a security question'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    if (_answerController.text.trim().isEmpty) {
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please enter your answer'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    widget.formData['securityQuestion'] = _selectedQuestion!;
    widget.formData['securityAnswer'] = _answerController.text.trim();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);

    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    StepIndicator(
                      currentStep: 2,
                      totalSteps: 4,
                      onBack: widget.onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 24),

                    // Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AuthTheme.primaryBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.security_outlined,
                        size: 36,
                        color: AuthTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Security Question',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'This will help you recover your account if you forget your password.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AuthTheme.textDark.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Content based on state
                    _buildContent(state),
                  ],
                ),
              ),
            ),

            // Next button - only enabled when questions loaded
            if (state is SignUpQuestionsLoaded)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: PrimaryActionButton(
                  label: 'Next',
                  onPressed: _saveAndNext,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SignUpState state) {
    if (state is SignUpLoadingQuestions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is SignUpQuestionsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AuthTheme.errorRed),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AuthTheme.textDark),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(signUpControllerProvider.notifier)
                      .loadSecurityQuestions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is SignUpQuestionsLoaded) {
      return Column(
        children: [
          // Security Question Dropdown
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB).withOpacity(0.5),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedQuestion,
                hint: Text(
                  'Select Security Question*',
                  style: TextStyle(
                    fontSize: 15,
                    color: AuthTheme.textDark.withOpacity(0.35),
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF9CA3AF),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
                items: state.questions.map((q) {
                  return DropdownMenuItem(
                    value: q,
                    child: Text(
                      q,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedQuestion = v),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Security Answer
          AuthInputField(
            controller: _answerController,
            hint: 'Your Answer*',
            textInputAction: TextInputAction.done,
          ),
        ],
      );
    }

    // Idle state - trigger load
    return const SizedBox.shrink();
  }
}
