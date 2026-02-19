import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BookingProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const BookingProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = 1; i <= totalSteps; i++) {
      final bool isActive = i == currentStep;
      final bool isCompleted = i < currentStep;

      // 1. Add Dot
      final double size = isActive ? 12.0 : 8.0;
      final Color color = (isActive || isCompleted)
          ? AppColors.primary // New Lighter Blue match
          : const Color(0xFFE0F2FE); // Light inactive

      children.add(
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      );

      // 2. Add Line (if not last step)
      if (i < totalSteps) {
        final bool isLineActive = i < currentStep;
        // Line connects i and i+1. It's active if we have passed step i.

        children.add(
          Expanded(
            child: Container(
              height: 2,
              color: isLineActive
                  ? AppColors.primary // New Lighter Blue match
                  : const Color(0xFFE0F2FE),
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
