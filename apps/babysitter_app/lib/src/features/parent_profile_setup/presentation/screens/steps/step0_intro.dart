import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';
import '../../../../../../common/widgets/primary_action_button.dart';

/// Step 0: Intro Screen (Hero Image + Bottom Sheet)
/// Matches Figma: Woman with phone, "Create Your Family Profile", Next button.
class Step0Intro extends ConsumerWidget {
  final VoidCallback onNext;
  final bool? isSitter;

  const Step0Intro({
    super.key,
    required this.onNext,
    this.isSitter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value?.user;
    final isSitterMode = isSitter ?? (user?.role == UserRole.sitter);

    return Scaffold(
      body: Stack(
        children: [
          // Hero Image (Full screen background)
          Positioned.fill(
            child: Image.asset(
              'assets/images/family_hero.jpg', // Placeholder, ensure asset exists
              fit: BoxFit.cover,
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSitterMode
                        ? 'Create Your Profile'
                        : 'Create Your Family Profile',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSitterMode
                        ? 'Let families get to know you — start building your sitter profile today.'
                        : 'Fill out your profile and tell us about your child’s unique needs so you can find the right sitter.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF667085),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next Button
                  SizedBox(
                    width: 160, // Fixed width from screenshot approx
                    child: PrimaryActionButton(
                      label: 'Let\'s Start',
                      onPressed: onNext,
                    ),
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
