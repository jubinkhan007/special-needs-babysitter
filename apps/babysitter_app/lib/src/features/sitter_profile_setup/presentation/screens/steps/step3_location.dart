import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';

class Step3Location extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Location({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step3Location> createState() => _Step3LocationState();
}

class _Step3LocationState extends ConsumerState<Step3Location> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = Color(0xFF88CBE6);

  @override
  Widget build(BuildContext context) {
    // Watch state to update UI if needed (e.g. show address in search bar)
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final controller = ref.read(sitterProfileSetupControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFD),
      appBar: OnboardingHeader(
        currentStep: 3,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 3, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.location_on_outlined,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Set Your Home Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Helps families find you nearby. You can update it anytime.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textDark.withOpacity(0.7),
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1))
                        ]),
                    child: TextField(
                      onChanged: (val) =>
                          controller.updateLocation(address: val),
                      controller: TextEditingController(text: state.address)
                        ..selection = TextSelection.fromPosition(
                            TextPosition(offset: state.address?.length ?? 0)),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: _textDark,
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter your address or city',
                        hintStyle: TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 16,
                            fontFamily: 'Inter'),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF98A2B3)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Use Current Location Button
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Simulating location fetch...')));
                      // Simulate fetching a location
                      Future.delayed(const Duration(seconds: 1), () {
                        controller.updateLocation(
                            address: 'San Francisco, CA',
                            lat: 37.7749,
                            lng: -122.4194);
                      });
                    },
                    icon: const Icon(Icons.my_location, color: _primaryBlue),
                    label: const Text('Use my Current Location',
                        style: TextStyle(
                            color: _primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primaryBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Map Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A), // Fallback dark background
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/map_placeholder.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image missing
                              return Container(
                                color: const Color(0xFF1A2B3C),
                                child: const Center(
                                  child: Icon(Icons.map,
                                      color: Colors.white24, size: 48),
                                ),
                              );
                            },
                          ),
                          // Overlay Gradient for better text visibility if needed, or matched dark map
                          Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                          // Pin
                          const Center(
                              child: Icon(Icons.location_on,
                                  color: _primaryBlue, size: 48)),

                          // Simulated "San Francisco" label if needed to match screenshot exactly?
                          // The screenshot shows a map view of SF.
                          // I'll leave it as image/pin for now.
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
            label: 'Save Location & Continue',
            onPressed: () {
              if (state.address == null || state.address!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please set a location')));
                return;
              }
              widget.onNext();
            },
          ),
        ),
      ),
    );
  }
}
