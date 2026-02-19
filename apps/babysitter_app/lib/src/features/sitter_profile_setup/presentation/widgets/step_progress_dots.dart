import 'package:core/core.dart';
import 'package:flutter/material.dart';

class StepProgressDots extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressDots({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isEven) {
            // Dot
            final stepIndex = index ~/ 2;
            return _buildDot(stepIndex + 1);
          } else {
            // Line
            final stepIndex = (index - 1) ~/ 2;
            return _buildConnectingLine(stepIndex + 1);
          }
        }),
      ),
    );
  }

  Widget _buildDot(int step) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;
    // Current step is larger in Figma?
    // Image 1 shows step 2 is active. It looks slightly larger or just emphasized?
    // Let's stick to simple active/inactive for now, or highlight current.
    // The previous code had `large` logic. Let's keep a subtle size diff if current.

    return Container(
      width: isCurrent ? 16 : 12,
      height: isCurrent ? 16 : 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceTint,
        shape: BoxShape.circle,
        // Optional: Border for current?
        border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
    );
  }

  Widget _buildConnectingLine(int step) {
    // Line connects step and step+1.
    // If step < currentStep, it's active (past).
    // If step == currentStep, it's active (current progress to next? No, usually not filled yet).
    // Actually, usually line is filled if we completed step.
    // Design shows line from 1 to 2 is filled. Line from 2 to 3 is empty.
    final isActive = step < currentStep;

    return Expanded(
      child: Container(
        height: 4, // Slightly thicker
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceTint,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
