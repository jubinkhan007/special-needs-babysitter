import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';

import '../../routing/routes.dart';
import 'presentation/widgets/auth_input_field.dart';
import '../../../common/widgets/primary_action_button.dart';
import 'presentation/widgets/social_login_row.dart';
import '../../../common/theme/auth_theme.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

String _normalizeRole(String role) {
  final value = role.toLowerCase();
  if (value == 'sitter' || value == 'babysitter') return 'sitter';
  if (value == 'parent' || value == 'family') return 'parent';
  return 'parent';
}

/// Sign in screen - Pixel-perfect matching Figma design
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.initialRole = 'parent'});

  final String initialRole;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (authState.hasError) {
      final appError = AppErrorHandler.parse(authState.error!);
      // Login-specific: 401 means invalid credentials, not session expired
      final message = appError.type == AppExceptionType.unauthorized
          ? 'Invalid email or password. Please try again.'
          : appError.message;
      AppToast.show(context, 
        SnackBar(
          content: Text(message),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
    }
    // Navigation handled by router redirect
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: Stack(
        children: [
          // Hero image at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.42,
            child: ClipPath(
              clipper: _BottomCurveClipper(),
              child: Image.asset(
                'assets/images/login_hero_image.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AuthTheme.primaryBlue.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.family_restroom,
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
            top: screenHeight * 0.36,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AuthTheme.backgroundColor,
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
                        'Welcome to Special\nNeeds sitter',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Email field (placeholder only)
                      AuthInputField(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field (placeholder only)
                      AuthInputField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      PrimaryActionButton(
                        label: 'Login',
                        onPressed: isLoading ? null : _signIn,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password (right-aligned)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.push(Routes.forgotPassword),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Social login section
                      const _SocialLoginSection(),
                      const SizedBox(height: 20),

                      // Sign up link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'SignUp',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    final role =
                                        _normalizeRole(widget.initialRole);
                                    context.go(
                                      Uri(
                                        path: Routes.signUp,
                                        queryParameters: {'role': role},
                                      ).toString(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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

/// Social login section with "Or Continue with" divider
class _SocialLoginSection extends StatelessWidget {
  const _SocialLoginSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFB8D4E3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or Continue with',
                style: TextStyle(
                  fontSize: 13,
                  color: AuthTheme.textDark.withOpacity(0.45),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFB8D4E3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Social buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              iconPath: 'assets/icons/facebook_icon.png',
              onTap: () {},
            ),
            const SizedBox(width: 16),
            _SocialButton(
              iconPath: 'assets/icons/google_icon.png',
              onTap: () {},
            ),
            const SizedBox(width: 16),
            _SocialButton(
              iconPath: 'assets/icons/apple_icon.png',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFB8D4E3),
            width: 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 22,
            height: 22,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.error_outline,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
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
