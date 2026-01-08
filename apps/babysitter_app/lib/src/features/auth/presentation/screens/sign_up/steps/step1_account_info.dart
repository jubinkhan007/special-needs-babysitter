import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/theme/auth_theme.dart';
import '../../../widgets/auth_input_field.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../../widgets/step_indicator.dart';
import '../../../widgets/social_login_row.dart';
import '../../../../../../routing/routes.dart';

/// Step 1: Account Info - Pixel-perfect matching Figma
class Step1AccountInfo extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final Map<String, String> formData;

  const Step1AccountInfo({
    super.key,
    required this.onNext,
    this.onBack,
    required this.formData,
  });

  @override
  State<Step1AccountInfo> createState() => _Step1AccountInfoState();
}

class _Step1AccountInfoState extends State<Step1AccountInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleInitialController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.formData['firstName']);
    _middleInitialController =
        TextEditingController(text: widget.formData['middleInitial']);
    _lastNameController =
        TextEditingController(text: widget.formData['lastName']);
    _emailController = TextEditingController(text: widget.formData['email']);
    _phoneController = TextEditingController(text: widget.formData['phone']);
    _agreedToTerms = widget.formData['agreedToTerms'] == 'true';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleInitialController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }

    widget.formData['firstName'] = _firstNameController.text.trim();
    widget.formData['middleInitial'] = _middleInitialController.text.trim();
    widget.formData['lastName'] = _lastNameController.text.trim();
    widget.formData['email'] = _emailController.text.trim();
    widget.formData['phone'] = _phoneController.text.trim();
    widget.formData['agreedToTerms'] = _agreedToTerms.toString();

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Step indicator (no back arrow for step 1)
                StepIndicator(
                  currentStep: 1,
                  totalSteps: 3,
                  onBack: widget.onBack,
                  onHelp: () {},
                  showBackButton: false, // No back on step 1
                ),
                const SizedBox(height: 24),

                // Icon box - bigger, more rounded, positioned lower
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AuthTheme.primaryBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    size: 36,
                    color: AuthTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),

                // Title - pure dark, not blue-tinted
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A), // Pure dark, not teal
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 24),

                // First Name
                AuthInputField(
                  controller: _firstNameController,
                  hint: 'First Name*',
                  textInputAction: TextInputAction.next,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 12), // Tighter spacing

                // Middle Initial
                AuthInputField(
                  controller: _middleInitialController,
                  hint: 'Middle Initial',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                // Last Name
                AuthInputField(
                  controller: _lastNameController,
                  hint: 'Last Name*',
                  textInputAction: TextInputAction.next,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Email
                AuthInputField(
                  controller: _emailController,
                  hint: 'Email*',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Required';
                    if (!v!.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Phone
                AuthInputField(
                  controller: _phoneController,
                  hint: 'Phone*',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Checkbox row - simple square, centered alignment
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Custom checkbox matching Figma
                    GestureDetector(
                      onTap: () =>
                          setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _agreedToTerms
                              ? AuthTheme.primaryBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _agreedToTerms
                                ? AuthTheme.primaryBlue
                                : const Color(0xFFD0D5DD),
                            width: 1.5,
                          ),
                        ),
                        child: _agreedToTerms
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A4A4A),
                          ),
                          children: const [
                            TextSpan(text: 'Agree with '),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Next button
                PrimaryActionButton(
                  label: 'Next',
                  onPressed: _saveAndNext,
                ),
                const SizedBox(height: 20), // More breathing room

                // Social login
                const SocialLoginRow(),
                const SizedBox(height: 20), // More breathing room

                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(Routes.signIn),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                        ),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
