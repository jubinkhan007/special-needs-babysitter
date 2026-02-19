import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';

class Step8HourlyRate extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step8HourlyRate({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step8HourlyRate> createState() => _Step8HourlyRateState();
}

class _Step8HourlyRateState extends ConsumerState<Step8HourlyRate> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = AppColors.primary;
  static const _greyText = Color(0xFF667085);
  static const _borderGrey = Color(0xFFD0D5DD);
  static const _inputBg = Colors.white;

  // Rate range configuration
  final List<double> _rates = List.generate(
    181, // $10 to $100 in 0.5 increments? (100-10)*2 + 1 = 181
    (index) => 10.0 + (index * 0.5),
  );

  void _showRatePicker() {
    final currentRate =
        ref.read(sitterProfileSetupControllerProvider).hourlyRate;
    final initialIndex = _rates.indexOf(currentRate);
    final safeIndex = initialIndex != -1 ? initialIndex : _rates.indexOf(15.0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Picker Toolbar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFEAECF0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: _greyText)),
                    ),
                    const Text(
                      'Select Hourly Rate',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done',
                          style: TextStyle(
                              color: _primaryBlue,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                      initialItem: safeIndex != -1 ? safeIndex : 0),
                  onSelectedItemChanged: (index) {
                    ref
                        .read(sitterProfileSetupControllerProvider.notifier)
                        .updateHourlyRate(_rates[index]);
                  },
                  children: _rates
                      .map((rate) => Center(
                            child: Text(
                              '\$${rate.toStringAsFixed(2)}/hr',
                              style: const TextStyle(
                                  fontSize: 18, color: _textDark),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 8,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 8, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Tile
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.attach_money,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title & Description
                  const Text(
                    'Set Your Hourly Rate',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Set your desired hourly rate for families to see.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _greyText,
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Hourly Rate Input
                  GestureDetector(
                    onTap: _showRatePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: _inputBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _borderGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${state.hourlyRate.toStringAsFixed(2)}/hr',
                            style: const TextStyle(
                              fontSize: 16,
                              color: _textDark,
                              fontFamily: 'Inter',
                            ),
                          ),
                          // Custom Up/Down Chevrons
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.expand_less,
                                  size: 16, color: Color(0xFF667085)),
                              Icon(Icons.expand_more,
                                  size: 16, color: Color(0xFF667085)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Checkbox Row
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: state.isRateNegotiable,
                          onChanged: (val) {
                            ref
                                .read(sitterProfileSetupControllerProvider
                                    .notifier)
                                .toggleRateNegotiable(val ?? false);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4)), // Square with radius
                          side: const BorderSide(
                              color: Color(0xFF667085), width: 1.5),
                          activeColor: _primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'I am open to negotiating my rate.',
                        style: TextStyle(
                          fontSize: 14,
                          color: _greyText,
                          fontFamily: 'Inter', // Assuming standard font
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: widget.onNext,
          ),
        ),
      ),
    );
  }
}
