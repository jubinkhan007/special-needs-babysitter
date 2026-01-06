import 'package:flutter/material.dart';

import '../../../../common/theme/auth_theme.dart';
import '../../../../common/widgets/auth_input_field.dart';
import '../../../../common/widgets/primary_action_button.dart';
import '../../../../common/widgets/step_indicator.dart';

/// Step 3: Set Password - Pixel-perfect matching Figma
class Step3Password extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, String> formData;

  const Step3Password({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.formData,
  });

  @override
  State<Step3Password> createState() => _Step3PasswordState();
}

class _Step3PasswordState extends State<Step3Password> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _securityAnswerController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _selectedSecurityQuestion;

  static const _securityQuestions = [
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
    _selectedSecurityQuestion = widget.formData['securityQuestion'];
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSecurityQuestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a security question'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    widget.formData['password'] = _passwordController.text;
    widget.formData['securityQuestion'] = _selectedSecurityQuestion!;
    widget.formData['securityAnswer'] = _securityAnswerController.text.trim();

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
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

                      // Step indicator (shows back on step 2)
                      StepIndicator(
                        currentStep: 2,
                        totalSteps: 3,
                        onBack: widget.onBack,
                        onHelp: () {},
                      ),
                      const SizedBox(height: 24),

                      // Icon box - bigger, more rounded
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AuthTheme.primaryBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 36,
                          color: AuthTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title - pure dark
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
                            color: const Color(0xFFE5E7EB).withOpacity(0.5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSecurityQuestion,
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
                            dropdownColor:
                                Colors.white, // White popup background
                            borderRadius:
                                BorderRadius.circular(8), // Rounded popup
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1A1A1A),
                            ),
                            items: _securityQuestions.map((q) {
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
                                setState(() => _selectedSecurityQuestion = v),
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

            // Next button pinned to bottom
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
}
