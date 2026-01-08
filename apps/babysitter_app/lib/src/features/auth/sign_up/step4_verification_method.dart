import 'package:flutter/material.dart';

import '../../../../common/theme/auth_theme.dart';
import '../../../../common/widgets/primary_action_button.dart';
import '../presentation/widgets/step_indicator.dart';

/// Step 4: Verification Method - Pixel-perfect matching Figma
class Step4VerificationMethod extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, String> formData;

  const Step4VerificationMethod({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.formData,
  });

  @override
  State<Step4VerificationMethod> createState() =>
      _Step4VerificationMethodState();
}

class _Step4VerificationMethodState extends State<Step4VerificationMethod> {
  String _selectedMethod = 'phone';

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.formData['verificationMethod'] ?? 'phone';
  }

  void _saveAndNext() {
    widget.formData['verificationMethod'] = _selectedMethod;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Step indicator
                    StepIndicator(
                      currentStep: 4,
                      totalSteps: 4,
                      onBack: widget.onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 24),

                    // Title - pure dark
                    const Text(
                      'Verification Method',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone option
                    _VerificationOption(
                      label: 'Phone',
                      isSelected: _selectedMethod == 'phone',
                      onTap: () => setState(() => _selectedMethod = 'phone'),
                    ),
                    const SizedBox(height: 12),

                    // Email option
                    _VerificationOption(
                      label: 'Email',
                      isSelected: _selectedMethod == 'email',
                      onTap: () => setState(() => _selectedMethod = 'email'),
                    ),
                  ],
                ),
              ),
            ),

            // Next button pinned to bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryActionButton(
                label: 'Next',
                onPressed: _saveAndNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VerificationOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AuthTheme.primaryBlue
                    : const Color(0xFFD0D5DD),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuthTheme.primaryBlue,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}
