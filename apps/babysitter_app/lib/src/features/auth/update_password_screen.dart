import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core.dart';

import '../../routing/routes.dart';
import 'presentation/widgets/auth_input_field.dart';
import '../../../common/widgets/primary_action_button.dart';

/// Update Password screen - Pixel-perfect matching Figma design
class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual password update logic
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to confirmation screen
    context.go(Routes.passwordUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Hero image at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.48,
            child: ClipPath(
              clipper: _BottomCurveClipper(),
              child: Image.asset(
                'assets/images/update_password_hero.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.secondary.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.lock_reset,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom card with form
          Positioned(
            top: screenHeight * 0.42,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Enter Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle with password requirements
                      Text(
                        'Please put a minimum 8 characters, one uppercase letter, one special character)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary.withOpacity(0.6),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Password field
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Minimum 8 characters required';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Must contain an uppercase letter';
                          }
                          if (!value
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Must contain a special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password field
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Save Password button
                      PrimaryActionButton(
                        label: 'Save Password',
                        onPressed: _isLoading ? null : _savePassword,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper for curved bottom edge on hero image
class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
