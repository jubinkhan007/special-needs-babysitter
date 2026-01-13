import 'package:flutter/material.dart';
import 'booking_progress_indicator.dart';

class BookingStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback? onHelp;

  const BookingStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F9FF), // Light blue background per Figma
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Back, Step Title, Help
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8), // Standard nav padding
            child: SizedBox(
              height: 44, // Standard hit area height
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 24,
                          color: Color(0xFF101828)), // Dark grey/black
                      onPressed: onBack,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                  ),
                  // Centered Title
                  Text(
                    'Step $currentStep of $totalSteps',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054), // Grey 700
                    ),
                  ),
                  // Help Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.help_outline_rounded,
                          size: 24, color: Color(0xFF667085)), // Grey 500
                      onPressed: onHelp ?? () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BookingProgressIndicator(
              currentStep: currentStep,
              totalSteps: totalSteps,
            ),
          ),
        ],
      ),
    );
  }
}
