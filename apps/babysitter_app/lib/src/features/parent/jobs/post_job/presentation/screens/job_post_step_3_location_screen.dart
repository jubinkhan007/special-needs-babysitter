import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../providers/job_post_providers.dart';
import '../controllers/job_post_controller.dart';
import 'job_post_step_header.dart';

/// Job Post Step 3: Location Details
/// Pixel-perfect implementation matching Figma design
class JobPostStep3LocationScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const JobPostStep3LocationScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<JobPostStep3LocationScreen> createState() =>
      _JobPostStep3LocationScreenState();
}

class _JobPostStep3LocationScreenState
    extends ConsumerState<JobPostStep3LocationScreen> {
  // Controllers
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  // Geocoding state
  bool _isGeocoding = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(jobPostControllerProvider);
    _streetAddressController.text = state.streetAddress;
    _unitController.text = state.aptUnit ?? '';
    _cityController.text = state.city;
    _stateController.text = state.state;
    _zipCodeController.text = state.zipCode;
  }

  // Design Constants
  static const _bgColor = Color(
      0xFFEAF6FF); // Light sky background (User requested different bg for step 3)
  static const _titleColor = Color(0xFF0B1736); // Deep navy
  static const _mutedText = Color(0xFF7C8A9A); // Grey
  static const _borderColor = Color(0xFFBFE3F7); // Light blue border
  static const _progressFill = Color(0xFF7FC9EE); // Active progress fill

  static const _primaryBtn = Color(0xFF8CCFF0); // Continue button
  static const _iconBoxFill =
      Color(0xFFD7F0FF); // Icon box fill (deeper light-blue)
  static const _iconBlue = Color(0xFF74BFEA); // Icon color

  @override
  void dispose() {
    _streetAddressController.dispose();
    _unitController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _geocodeAddress() async {
    final street = _streetAddressController.text.trim();
    final apt = _unitController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipCodeController.text.trim();

    if (street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required address fields first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }

    setState(() => _isGeocoding = true);

    try {
      // Build address string
      final parts = [street, apt, city, '$state $zip']
          .where((p) => p.isNotEmpty)
          .toList();
      final fullAddress = parts.join(', ');

      // Geocode address
      final addresses = await locationFromAddress(fullAddress);

      if (!mounted) return null;

      if (addresses.isEmpty) {
        setState(() => _isGeocoding = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address could not be found. Please verify.'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }

      final location = addresses.first;
      setState(() => _isGeocoding = false);

      return {
        'latitude': location.latitude,
        'longitude': location.longitude,
      };
    } catch (e) {
      if (!mounted) return null;
      setState(() => _isGeocoding = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobPostState>(jobPostControllerProvider, (previous, next) {
      if (previous?.streetAddress != next.streetAddress) {
        _streetAddressController.text = next.streetAddress;
      }
      if (previous?.aptUnit != next.aptUnit) {
        _unitController.text = next.aptUnit ?? '';
      }
      if (previous?.city != next.city) _cityController.text = next.city;
      if (previous?.state != next.state) _stateController.text = next.state;
      if (previous?.zipCode != next.zipCode) {
        _zipCodeController.text = next.zipCode;
      }
    });

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            // Step 3 of 5
            JobPostStepHeader(
              activeStep: 3,
              totalSteps: 5,
              onBack: widget.onBack,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Icon Card
                    _buildIconCard(),

                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Where Do You Need Care?',
                      style: TextStyle(
                        fontSize: 28, // ~28-32
                        fontWeight: FontWeight.w800, // ExtraBold
                        color: _titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Street Address Field
                    _buildField(
                      controller: _streetAddressController,
                      hint: 'Street Address*',
                    ),

                    const SizedBox(height: 16), // Gap ~16-18

                    // Apt/Unit/Suite Field
                    _buildField(
                      controller: _unitController,
                      hint: 'Apt/Unit/Suite*',
                    ),

                    const SizedBox(height: 16),

                    // City Field
                    _buildField(
                      controller: _cityController,
                      hint: 'City*',
                    ),

                    const SizedBox(height: 16),

                    // State Field
                    _buildField(
                      controller: _stateController,
                      hint: 'State*',
                    ),

                    const SizedBox(height: 16),

                    // Zip Code Field
                    _buildField(
                      controller: _zipCodeController,
                      hint: 'Zip Code*',
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard() {
    return Container(
      width: 96, // ~92–104
      height: 96,
      decoration: BoxDecoration(
        color: _iconBoxFill,
        borderRadius: BorderRadius.circular(24), // ~22–26
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 44, // ~40–48
            color: _iconBlue,
          ),
          // Add a plus sign inside if needed, generic composition
          Positioned(
            top: 26,
            child: Icon(
              Icons.add,
              size: 16,
              color: _iconBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 64, // ~64–72
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // ~14–16
        border: Border.all(color: _borderColor, width: 1.3), // ~1.2–1.5
      ),
      child: TextField(
        controller: controller,
        cursorColor: _progressFill,
        keyboardType: keyboardType,
        inputFormatters: _numericInputFormatters(keyboardType),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _titleColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            color: _mutedText,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20), // inner padding: left 18–20, vertical 18–20
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  List<TextInputFormatter>? _numericInputFormatters(
      TextInputType? keyboardType) {
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  Future<void> _onContinue() async {
    // Check if required fields are empty
    if (_streetAddressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill in all required fields (Street, City, Zip).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate Zip Code (must be exactly 5 digits)
    final zipRegex = RegExp(r'^\d{5}$');
    if (!zipRegex.hasMatch(_zipCodeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 5-digit Zip Code.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Geocode the address
    final coordinates = await _geocodeAddress();
    if (coordinates == null) {
      return;
    }

    // Update controller with real coordinates
    ref.read(jobPostControllerProvider.notifier).updateLocation(
          streetAddress: _streetAddressController.text,
          aptUnit: _unitController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipCodeController.text,
          latitude: coordinates['latitude'] as double,
          longitude: coordinates['longitude'] as double,
        );

    if (mounted) {
      widget.onNext();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(24, 0, 24, 20), // Bottom padding: ~18–22
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          TextButton(
            onPressed: widget.onBack,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Previous',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085), // Grey
              ),
            ),
          ),

          // Continue Button
          GestureDetector(
            onTap: _isGeocoding ? null : _onContinue,
            child: Container(
              width: 190, // width ~180–210
              height: 60, // height ~56–66
              decoration: BoxDecoration(
                color: _isGeocoding ? Colors.grey[400] : _primaryBtn,
                borderRadius: BorderRadius.circular(15), // ~14–16
              ),
              child: Center(
                child: _isGeocoding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700, // bold
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
