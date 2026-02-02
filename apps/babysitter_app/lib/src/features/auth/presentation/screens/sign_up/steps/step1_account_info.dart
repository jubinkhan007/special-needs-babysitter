import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:domain/domain.dart';
import 'package:core/core.dart';

import '../../../../../../../common/theme/auth_theme.dart';
import '../../../widgets/auth_input_field.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../../widgets/step_indicator.dart';
import '../../../widgets/social_login_row.dart';
import '../../../../../../routing/routes.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../../../controllers/sign_up_providers.dart';

/// Step 1: Account Info - Pixel-perfect matching Figma
class Step1AccountInfo extends ConsumerStatefulWidget {
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
  ConsumerState<Step1AccountInfo> createState() => _Step1AccountInfoState();
}

class _Step1AccountInfoState extends ConsumerState<Step1AccountInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleInitialController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _agreedToTerms = false;
  bool _isCheckingUniqueness = false;

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

  Future<void> _saveAndNext() async {
    if (_isCheckingUniqueness) return;
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      AppToast.show(context, 
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
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    widget.formData['email'] = email;
    widget.formData['phone'] = phone;
    widget.formData['agreedToTerms'] = _agreedToTerms.toString();

    setState(() => _isCheckingUniqueness = true);
    try {
      final useCase = ref.read(checkUniquenessUseCaseProvider);
      final result = await useCase.call(
        UniquenessCheckPayload(
          email: email,
          phone: phone,
        ),
      );

      if (!mounted) return;

      if (result.success && result.available) {
        widget.onNext();
      } else {
        AppToast.show(
          context,
          SnackBar(
            content: Text(
              result.message.isNotEmpty
                  ? result.message
                  : 'Email or phone number already exists',
            ),
            backgroundColor: AuthTheme.errorRed,
          ),
        );
      }
    } on Failure catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        SnackBar(
          content: Text(e.message),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppToast.show(
        context,
        const SnackBar(
          content: Text('Failed to check availability. Please try again.'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingUniqueness = false);
      }
    }
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
                Text(
                  widget.formData['role'] == 'sitter'
                      ? 'Create Your Sitter Account'
                      : 'Create Your Family Account',
                  style: const TextStyle(
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
                  maxLength: 50,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'First name is required';
                    if (v!.length < 2) return 'Must be at least 2 characters';
                    if (v.length > 50) return 'Must be 50 characters or less';
                    return null;
                  },
                ),
                const SizedBox(height: 12), // Tighter spacing

                // Middle Name
                AuthInputField(
                  controller: _middleInitialController,
                  hint: 'Middle Name (Optional)',
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),

                // Last Name
                AuthInputField(
                  controller: _lastNameController,
                  hint: 'Last Name*',
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Last name is required';
                    if (v!.length < 2) return 'Must be at least 2 characters';
                    if (v.length > 50) return 'Must be 50 characters or less';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Email
                AuthInputField(
                  controller: _emailController,
                  hint: 'Email*',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  maxLength: 254,
                  helperText: 'Valid email format: name@example.com',
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Email is required';
                    if (v!.length < 5) return 'Email must be at least 5 characters';
                    if (v.length > 254) return 'Email must be 254 characters or less';
                    // RFC 5322 compliant email regex
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(v)) {
                      return 'Please enter a valid email address';
                    }
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
                  maxLength: 14,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Phone number is required';
                    // Validate US phone number format
                    final phoneRegex = RegExp(r'^[\d\s\-\(\)\+\.]+$');
                    if (!phoneRegex.hasMatch(v!)) {
                      return 'Invalid phone number format';
                    }
                    // Extract digits and check count
                    final digits = v.replaceAll(RegExp(r'[^\d]'), '');
                    if (digits.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    if (digits.length > 15) {
                      return 'Phone number is too long';
                    }
                    return null;
                  },
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
                  isLoading: _isCheckingUniqueness,
                  onPressed: _saveAndNext,
                ),
                const SizedBox(height: 20), // More breathing room

                // Social login
                const SocialLoginRow(),
                const SizedBox(height: 20), // More breathing room

                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final from = GoRouterState.of(context).uri.queryParameters['from'];
                      final params = <String, String>{};
                      if (from != null) {
                        params['from'] = from;
                      }
                      context.go(Uri(path: Routes.signIn, queryParameters: params).toString());
                    },
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
