import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 7: Profile Complete - Success screen with hero image
class Step7Complete extends ConsumerWidget {
  final VoidCallback onFinish;

  const Step7Complete({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Fallback color
      body: Stack(
        children: [
          // 1. Hero Image (Top ~65%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Image.asset(
              'assets/images/profile_complete_hero.png', // Using available asset
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primary, // Fallback if image fails
                child: const Center(
                  child:
                      Icon(Icons.check_circle, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),

          // 2. Bottom Sheet (White, Rounded)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  // Title with Emoji
                  const Text(
                    'Profile Complete! 🎉',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'You’re all set! Start posting jobs and\nconnect with trusted babysitters nearby.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF475467), // Cool grey
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Primary Button (Light Blue)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onFinish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Light blue
                        foregroundColor: AppColors.textOnButton,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Post a Job Now'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Secondary Button (Text)
                  TextButton(
                    onPressed: onFinish, // Or logic for explore?
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF475467),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Explore Available Sitters'),
                  ),
                  // Extra SafeArea padding at bottom handled by padding + SafeArea wrapper if needed
                  // But straightforward container padding is often cleaner for bottom sheets
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
