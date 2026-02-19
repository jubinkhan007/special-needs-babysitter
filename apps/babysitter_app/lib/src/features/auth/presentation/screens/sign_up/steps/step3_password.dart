import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';

import 'package:core/core.dart';

import '../../../widgets/auth_input_field.dart';
import '../../../../../../../common/widgets/primary_action_button.dart';
import '../../../widgets/step_indicator.dart';
import '../../../controllers/sign_up_controller.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Step 3: Set Password - Triggers register + sendOtp on Next
class Step3Password extends ConsumerStatefulWidget {
  final void Function(RegisteredUser user) onSuccess;
  final VoidCallback onBack;
  final Map<String, String> formData;

  const Step3Password({
    super.key,
    required this.onSuccess,
    required this.onBack,
    required this.formData,
  });

  @override
  ConsumerState<Step3Password> createState() => _Step3PasswordState();
}

class _Step3PasswordState extends ConsumerState<Step3Password> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController =
        TextEditingController(text: widget.formData['password']);
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    // Save password to form data
    widget.formData['password'] = _passwordController.text;

    // Call controller to register and send OTP
    final controller = ref.read(signUpControllerProvider.notifier);
    final user = await controller.submitRegistration(widget.formData);

    if (!mounted) return;

    if (user != null) {
      // Both register and sendOtp succeeded
      widget.onSuccess(user);
    } else {
      // Error occurred - state already has error message
      final state = ref.read(signUpControllerProvider);
      if (state is SignUpError) {
        AppToast.show(context, 
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final isSubmitting = state is SignUpSubmitting;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        currentStep: 3,
                        totalSteps: 4,
                        onBack: isSubmitting ? null : widget.onBack,
                        onHelp: () {},
                      ),
                      const SizedBox(height: 24),

                      // Icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 36,
                          color: AppColors.secondary,
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
                      const SizedBox(height: 8),

                      Text(
                        'Password must be at least 8 characters',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary.withOpacity(0.6),
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
                          if (v!.length < 8) return 'Min 8 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password
                      AuthInputField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password*',
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryActionButton(
                label: 'Create Account',
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
