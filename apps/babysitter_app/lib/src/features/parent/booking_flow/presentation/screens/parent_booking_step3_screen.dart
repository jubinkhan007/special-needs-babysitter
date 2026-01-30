import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../widgets/booking_text_field.dart';
import '../widgets/section_header.dart';
import 'parent_booking_step4_screen.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class ParentBookingStep3Screen extends ConsumerStatefulWidget {
  const ParentBookingStep3Screen({super.key});

  @override
  ConsumerState<ParentBookingStep3Screen> createState() =>
      _ParentBookingStep3ScreenState();
}

class _ParentBookingStep3ScreenState
    extends ConsumerState<ParentBookingStep3Screen> {
  // Address Controllers
  final _streetController = TextEditingController();
  final _aptController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Emergency Controllers
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();

  // Geocoding state
  bool _isGeocoding = false;
  bool _addressVerified = false;
  String? _verificationMessage;

  @override
  void dispose() {
    _streetController.dispose();
    _aptController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  Future<void> _geocodeAddress() async {
    // Build full address string from fields
    final street = _streetController.text.trim();
    final apt = _aptController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();

    if (street.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty) {
      if (!mounted) return;
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please fill in all required address fields first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
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

      if (!mounted) return;

      if (addresses.isEmpty) {
        setState(() {
          _isGeocoding = false;
          _addressVerified = false;
          _verificationMessage =
              'Address not found. Please check and try again.';
        });
        AppToast.show(context, 
          const SnackBar(
            content: Text('Address could not be found. Please verify.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final location = addresses.first;

      // Update provider with coordinates
      ref.read(bookingFlowProvider.notifier).updateLocationCoordinates(
            latitude: location.latitude,
            longitude: location.longitude,
          );

      setState(() {
        _isGeocoding = false;
        _addressVerified = true;
        _verificationMessage =
            'Address verified! (${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})';
      });

      AppToast.show(context, 
        const SnackBar(
          content: Text('Address verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGeocoding = false;
        _addressVerified = false;
        _verificationMessage = 'Error: Unable to verify address.';
      });
      AppToast.show(context, 
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // Light blue background
      body: Column(
        children: [
          // Header (Includes Progress Indicator)
          BookingStepHeader(
            currentStep: 3,
            totalSteps: 4,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Where Do You Need Care?
                  // Spacing determined by BookingStepHeader bottom padding and Figma.
                  // Step 2 had tight spacing.
                  const Text(
                    'Where Do You Need Care?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Address Fields
                  BookingTextField(
                    hintText: 'Street Address*',
                    controller: _streetController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Apt/Unit/Suite*',
                    controller: _aptController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'City*',
                    controller: _cityController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'State*',
                    controller: _stateController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Zip Code*',
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // Verify Address Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGeocoding ? null : _geocodeAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF88CBE6),
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: _isGeocoding
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.location_on, color: Colors.white),
                      label: Text(
                        _isGeocoding
                            ? 'Verifying...'
                            : _addressVerified
                                ? 'Address Verified ✓'
                                : 'Verify Address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Verification Message
                  if (_verificationMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _verificationMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _addressVerified ? Colors.green : Colors.red,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24), // Spacing before divider

                  // Divider
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE4E7EC), // Light grey divider
                  ),

                  const SizedBox(height: 24), // Spacing after divider

                  // Section Header: Emergency Contact (Required)
                  const SectionHeader(
                    title: 'Emergency Contact',
                  ),

                  const SizedBox(height: 16),

                  // Emergency Fields
                  BookingTextField(
                    hintText: 'Name*',
                    controller: _emergencyNameController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Phone Number*',
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Relationship*',
                    controller: _emergencyRelationController,
                  ),

                  // Bottom spacing
                  SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom + 60),
                ],
              ),
            ),
          ),

          // Bottom Sticky Button
          Container(
            color: const Color(0xFFF0F9FF),
            padding: EdgeInsets.fromLTRB(
                24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
            child: BookingPrimaryBottomButton(
              text: 'Next',
              onPressed: () {
                // Address Validation
                if (_streetController.text.isEmpty ||
                    _cityController.text.isEmpty ||
                    _stateController.text.isEmpty ||
                    _zipController.text.isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please fill in all required address fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Zip Code Validation
                final zipRegex = RegExp(r'^\d{5}$');
                if (!zipRegex.hasMatch(_zipController.text)) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter a valid 5-digit Zip Code.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Emergency Contact Validation (Required)
                if (_emergencyNameController.text.trim().isEmpty ||
                    _emergencyPhoneController.text.trim().isEmpty ||
                    _emergencyRelationController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please fill in all emergency contact fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Save to provider
                ref.read(bookingFlowProvider.notifier).updateStep3(
                      streetAddress: _streetController.text,
                      aptUnit: _aptController.text.isNotEmpty
                          ? _aptController.text
                          : null,
                      city: _cityController.text,
                      addressState: _stateController.text,
                      zipCode: _zipController.text,
                      emergencyContactName: _emergencyNameController.text.trim(),
                      emergencyContactPhone: _emergencyPhoneController.text.trim(),
                      emergencyContactRelation: _emergencyRelationController.text.trim(),
                    );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentBookingStep4Screen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
