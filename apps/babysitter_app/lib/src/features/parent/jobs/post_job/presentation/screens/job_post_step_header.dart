import 'package:flutter/material.dart';

class JobPostStepHeader extends StatelessWidget {
  final int activeStep; // 1-based index (1 to 5)
  final int totalSteps;
  final VoidCallback? onBack;

  const JobPostStepHeader({
    super.key,
    required this.activeStep,
    this.totalSteps = 5,
    this.onBack,
  });

  static const _mutedText = Color(0xFF7C8A9A); // Grey
  static const _progressTrack = Color(0xFFBFE3F7); // Inactive progress
  static const _progressFill = Color(0xFF7FC9EE); // Active progress

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Back Arrow
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: _mutedText,
                ),
              ),

              // Center Text
              Expanded(
                child: Center(
                  child: Text(
                    'Step $activeStep of $totalSteps',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _mutedText,
                    ),
                  ),
                ),
              ),

              // Help Icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _mutedText, width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _mutedText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Progress Indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: List.generate(totalSteps * 2 - 1, (index) {
              // Even indices are dots, odd indices are lines
              if (index % 2 == 0) {
                final stepIndex = index ~/ 2 + 1;
                // A step is "active" if it is the current step
                // A step is "filled" if it is <= current step (completed or active)
                final isActiveStep = stepIndex == activeStep;
                final isCompletedOrActive = stepIndex <= activeStep;

                return _buildDot(
                  filled: isCompletedOrActive,
                  large:
                      isActiveStep, // Only the current step dot is large? Or just filled ones?
                  // Reviewing design: usually current + completed are filled.
                  // The prompt says: "Step 4: active (filled + slightly emphasized)"
                  // So we'll make the current step slightly larger or emphasized if desired,
                  // but primary distinction is filled vs track color.
                );
              } else {
                final stepIndex = (index - 1) ~/ 2 + 1;
                // Line connects stepIndex to stepIndex + 1
                // Line is active if the NEXT step is also reached/active?
                // Typically line N is active if step N+1 is active/completed.
                // e.g. Line 1 (between 1 and 2) is active if we are at step 2 or greater.
                final nextStepIndex = stepIndex + 1;
                final isLineActive = nextStepIndex <= activeStep;

                return _buildConnectingLine(active: isLineActive);
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDot({required bool filled, bool large = false}) {
    return Container(
      width: large ? 16 : 12,
      height: large ? 16 : 12,
      decoration: BoxDecoration(
        color: filled ? _progressFill : _progressTrack.withValues(alpha: 0.5),
        shape: BoxShape.circle,
        // Optional active/large border styling
        border: (large && filled)
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: (large && filled)
            ? [
                BoxShadow(
                  color: _progressFill.withValues(alpha: 0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
    );
  }

  Widget _buildConnectingLine({required bool active}) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? _progressFill : _progressTrack,
      ),
    );
  }
}
