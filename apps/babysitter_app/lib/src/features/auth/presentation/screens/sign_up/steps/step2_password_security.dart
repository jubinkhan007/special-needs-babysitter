import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';

import '../../../../../../../common/theme/auth_theme.dart';
import '../../../widgets/auth_input_field.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../../widgets/step_indicator.dart';
import '../../../controllers/sign_up_controller.dart';

/// Step 2: Password + Security Question (combined per Figma design)
/// Loads security questions from API, triggers register + sendOtp on Next
class Step2PasswordSecurity extends ConsumerStatefulWidget {
  final void Function(RegisteredUser user) onSuccess;
  final VoidCallback onBack;
  final Map<String, String> formData;

  const Step2PasswordSecurity({
    super.key,
    required this.onSuccess,
    required this.onBack,
    required this.formData,
  });

  @override
  ConsumerState<Step2PasswordSecurity> createState() =>
      _Step2PasswordSecurityState();
}

class _Step2PasswordSecurityState extends ConsumerState<Step2PasswordSecurity> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _securityAnswerController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _selectedQuestion;

  // Hardcoded fallback questions if API fails
  static const _fallbackQuestions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'What city were you born in?',
    'What is your favorite movie?',
    'What was the name of your elementary school?',
  ];

  @override
  void initState() {
    super.initState();
    _passwordController =
        TextEditingController(text: widget.formData['password']);
    _confirmPasswordController = TextEditingController();
    _securityAnswerController =
        TextEditingController(text: widget.formData['securityAnswer']);
    _selectedQuestion = widget.formData['securityQuestion'];

    // Load security questions on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signUpControllerProvider.notifier).loadSecurityQuestions();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  List<String> _getQuestions(SignUpState state) {
    if (state is SignUpQuestionsLoaded) {
      return state.questions;
    }
    return _fallbackQuestions;
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedQuestion == null || _selectedQuestion!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a security question'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    // Save to form data
    widget.formData['password'] = _passwordController.text;
    widget.formData['securityQuestion'] = _selectedQuestion!;
    widget.formData['securityAnswer'] = _securityAnswerController.text.trim();

    // Call controller to register and send OTP
    final controller = ref.read(signUpControllerProvider.notifier);
    final user = await controller.submitRegistration(widget.formData);

    if (!mounted) return;

    if (user != null) {
      widget.onSuccess(user);
    } else {
      final state = ref.read(signUpControllerProvider);
      if (state is SignUpError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AuthTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final isSubmitting = state is SignUpSubmitting;
    final isLoadingQuestions = state is SignUpLoadingQuestions;
    final questions = _getQuestions(state);

    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      StepIndicator(
                        currentStep: 2,
                        totalSteps: 3,
                        onBack: isSubmitting ? null : widget.onBack,
                        onHelp: () {},
                      ),
                      const SizedBox(height: 24),

                      // Icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AuthTheme.primaryBlue.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 36,
                          color: AuthTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Set Your Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password
                      AuthInputField(
                        controller: _passwordController,
                        hint: 'Password*',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v?.isEmpty == true) return 'Required';
                          if (v!.length < 6) return 'Min 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password
                      AuthInputField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password*',
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (v) {
                          if (v?.isEmpty == true) return 'Required';
                          if (v != _passwordController.text) {
                            return 'Passwords don\'t match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Security Question Dropdown
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB).withAlpha(128),
                          ),
                        ),
                        child: isLoadingQuestions
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedQuestion,
                                  hint: Text(
                                    'Select Security Question*',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AuthTheme.textDark.withAlpha(89),
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
                                  items: questions.map((q) {
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
                                  onChanged: (v) =>
                                      setState(() => _selectedQuestion = v),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),

                      // Security Answer
                      AuthInputField(
                        controller: _securityAnswerController,
                        hint: 'Answer to Security Question*',
                        textInputAction: TextInputAction.done,
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryActionButton(
                label: 'Next',
                onPressed: isSubmitting ? null : _submitRegistration,
                isLoading: isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
