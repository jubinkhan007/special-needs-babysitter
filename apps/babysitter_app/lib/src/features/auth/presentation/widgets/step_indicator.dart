import 'package:flutter/material.dart';

import 'package:core/core.dart';

/// Pixel-perfect step indicator matching Figma design
/// - No back arrow on step 1
/// - Light gray text, regular weight
/// - Thin rounded pill progress segments
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;
  final String? title;
  final bool showBackButton;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onHelp,
    this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row: Back button (optional), Title/Step, Help button
        Row(
          children: [
            // Back button - only show if not step 1 and showBackButton is true
            if (showBackButton && currentStep > 1 && onBack != null)
              GestureDetector(
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                ),
              )
            else
              const SizedBox(width: 20),

            const Spacer(),

            // Title or Step indicator - lighter gray, regular weight
            Text(
              title ?? 'Step $currentStep of $totalSteps',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400, // Regular weight
                color: AppColors.textPrimary.withValues(alpha: 0.5), // Lighter gray
              ),
            ),

            const Spacer(),

            // Help button
            if (onHelp != null)
              GestureDetector(
                onTap: onHelp,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.textPrimary.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 22),
          ],
        ),
        const SizedBox(height: 12),

        // Progress bar - thin rounded pills with even spacing
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
                height: 3, // Thinner
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.secondary
                      : AppColors.secondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(1.5), // Rounded pill
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
