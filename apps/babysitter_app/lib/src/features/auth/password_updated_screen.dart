import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core.dart';

import '../../routing/routes.dart';

/// Password Updated Confirmation screen - Pixel-perfect matching Figma design
class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Hero image at top (full width, ~58% height)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.58,
            child: Image.asset(
              'assets/images/password_updated_hero.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.secondary.withValues(alpha: 0.3),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),

          // Bottom card with confirmation
          Positioned(
            top: screenHeight * 0.52,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'Password Updated.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Success message line 1
                    const Text(
                      'You have successfully updated your password.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Success message line 2
                    const Text(
                      'Now you can login using your new password.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Login button (centered, narrower)
                    SizedBox(
                      width: 140,
                      height: 54, // Taller to prevent clipping
                      child: ElevatedButton(
                        onPressed: () => context.go(Routes.signIn),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.textOnButton,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
