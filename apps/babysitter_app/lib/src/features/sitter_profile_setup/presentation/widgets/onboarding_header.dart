import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback? onHelp;

  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF3FAFD), // Match screen bg
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
        onPressed: onBack,
      ),
      title: Text(
        'Step $currentStep of $totalSteps',
        style: const TextStyle(
          color: Color(0xFF667085),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: Color(0xFF667085)),
          onPressed: onHelp ?? () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
