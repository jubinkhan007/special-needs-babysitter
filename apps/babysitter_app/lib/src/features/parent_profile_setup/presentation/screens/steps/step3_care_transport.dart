import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';

/// Step 3: Care Approach & Transport
/// Matches Figma: Heart/Person icon, Care Approach text area, Transport Notes,
/// Pick-up/Drop-off logic, Special Accommodations.
class Step3CareTransport extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step3CareTransport({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step3CareTransport> createState() => _Step3CareTransportState();
}

class _Step3CareTransportState extends ConsumerState<Step3CareTransport> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _careApproachController;
  late final TextEditingController _transportNotesController;
  late final TextEditingController _pickupRequirementsController;
  late final TextEditingController _accomodationsController;

  // Checkboxes
  bool _needsPickup = false;
  bool _needsDropoff = false;

  static const _bgBlue = Color(0xFFF3FAFD);

  @override
  void initState() {
    super.initState();
    final data =
        widget.profileData['careTransport'] as Map<String, dynamic>? ?? {};
    _careApproachController = TextEditingController(text: data['careApproach']);
    _transportNotesController =
        TextEditingController(text: data['transportNotes']);
    _pickupRequirementsController =
        TextEditingController(text: data['pickupRequirements']);
    _accomodationsController =
        TextEditingController(text: data['accomodations']);
    _needsPickup = data['needsPickup'] ?? false;
    _needsDropoff = data['needsDropoff'] ?? false;
  }

  @override
  void dispose() {
    _careApproachController.dispose();
    _transportNotesController.dispose();
    _pickupRequirementsController.dispose();
    _accomodationsController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      widget.profileData['careTransport'] = {
        'careApproach': _careApproachController.text,
        'transportNotes': _transportNotesController.text,
        'needsPickup': _needsPickup,
        'needsDropoff': _needsDropoff,
        'pickupRequirements': _pickupRequirementsController.text,
        'accomodations': _accomodationsController.text,
      };
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlue,
      appBar: AppBar(
        backgroundColor: _bgBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Step 3 of 4',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF667085)),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                _buildDot(active: true),
                _buildConnectingLine(active: true),
                _buildDot(active: true),
                _buildConnectingLine(active: true),
                _buildDot(active: true, large: true), // Step 3 active
                _buildConnectingLine(),
                _buildDot(active: false),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6F0FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.favorite_outline, // Heart icon like Figma
                        size: 40,
                        color: AuthTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Care Approach & Transport',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828), // Darker text
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Care Approach
                    _buildTextArea(
                      controller: _careApproachController,
                      hint:
                          'Describe your preferred care approach or philosophy for your child\'s unique needs.',
                      height: 120,
                    ),
                    const SizedBox(height: 24),

                    // Transportation Notes Label
                    const Text(
                      'Transportation Notes (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344054), // Dark grey
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextArea(
                      controller: _transportNotesController,
                      hint: 'Enter Transport Notes*',
                      height: 52, // Single line height match
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),

                    // Disclaimer
                    Text(
                      'Note: Special Needs Sitters does not provide or coordinate transportation services. Any transportation arrangements are made directly between families and sitters.',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF475467), // Cool grey
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pickup Checkbox
                    _buildCheckbox(
                      'Does your child need to be picked up from school, an activity, or therapy?',
                      _needsPickup,
                      (v) => setState(() => _needsPickup = v!),
                    ),
                    const SizedBox(height: 16),

                    // Dropoff Checkbox
                    _buildCheckbox(
                      'Does your child need to be dropped  off at therapy, school, or an activity?',
                      _needsDropoff,
                      (v) => setState(() => _needsDropoff = v!),
                    ),
                    const SizedBox(height: 24),

                    // Pickup/Dropoff Requirements
                    _buildTextArea(
                      controller: _pickupRequirementsController,
                      hint: 'Pickup/Drop-Off Requirements...',
                      height: 100, // Matches visual height
                    ),
                    const SizedBox(height: 16),

                    // Special Accommodations
                    _buildTextArea(
                      controller: _accomodationsController,
                      hint: 'Special Accommodations Description...',
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Color(0xFFF3FAFD), // Match bg
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF88CBE6), // Light blue from design
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    required double height,
    int? maxLines,
  }) {
    // Explicit white filled container with proper border to fix "Dark" issue
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines, // Null for multiline/expands usually
        expands: maxLines == null,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: Color(0xFF101828), // Dark Text Color Explicitly
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF98A2B3), // Lighter placeholder
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFEAECF0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFEAECF0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AuthTheme.primaryBlue),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF88CBE6) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: value
                        ? const Color(0xFF88CBE6)
                        : const Color(0xFFD0D5DD),
                    width: 1.5),
              ),
              child: value
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF344054), // Dark grey
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active, bool large = false}) {
    return Container(
      width: large ? 16 : 12,
      height: large ? 16 : 12,
      decoration: BoxDecoration(
        color: active ? AuthTheme.primaryBlue : const Color(0xFFE0F2F9),
        shape: BoxShape.circle,
        border: (active && large)
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
    );
  }

  Widget _buildConnectingLine({bool active = false}) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? AuthTheme.primaryBlue : const Color(0xFFE0F2F9),
      ),
    );
  }
}
