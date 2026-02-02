import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../../data/models/booking_flow_state.dart';
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
  final _emergencyEmailController = TextEditingController();
  final _emergencyAddressController = TextEditingController();
  final _specialInstructionsController = TextEditingController();

  // Geocoding state
  bool _isGeocoding = false;
  bool _addressVerified = false;
  String? _verificationMessage;

  // Validation constants
  static const int _maxNameLength = 50;
  static const int _maxRelationLength = 50;
  static const int _maxEmailLength = 254;
  static const int _maxAddressLength = 200;
  static const int _maxInstructionsLength = 500;
  static const int _maxStreetLength = 100;
  static const int _maxCityLength = 50;
  static const int _maxStateLength = 50;
  static const int _maxZipLength = 5;

  @override
  void initState() {
    super.initState();
    // Load existing state from provider
    final state = ref.read(bookingFlowProvider);
    _streetController.text = state.streetAddress ?? '';
    _aptController.text = state.aptUnit ?? '';
    _cityController.text = state.city ?? '';
    _stateController.text = state.state ?? '';
    _zipController.text = state.zipCode ?? '';
    _emergencyNameController.text = state.emergencyContactName ?? '';
    _emergencyPhoneController.text = state.emergencyContactPhone ?? '';
    _emergencyRelationController.text = state.emergencyContactRelation ?? '';
    _emergencyEmailController.text = state.emergencyContactEmail ?? '';
    _emergencyAddressController.text = state.emergencyContactAddress ?? '';
    _specialInstructionsController.text =
        state.emergencyContactInstructions ?? '';
  }

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
    _emergencyEmailController.dispose();
    _emergencyAddressController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  // Validation helper methods
  bool _isValidEmail(String email) {
    if (email.isEmpty) return true; // Email is optional
    // RFC 5322 compliant regex for email validation
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    return emailRegex.hasMatch(email) && email.length <= _maxEmailLength;
  }

  bool _isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Remove all non-digit characters for validation
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    // US phone numbers should be 10 digits
    return digitsOnly.length == 10;
  }

  String _formatPhoneNumber(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    }
    return phone;
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
    // Listen for state changes to sync when navigating back
    ref.listen<BookingFlowState>(bookingFlowProvider, (previous, next) {
      if (previous?.streetAddress != next.streetAddress) {
        _streetController.text = next.streetAddress ?? '';
      }
      if (previous?.aptUnit != next.aptUnit) {
        _aptController.text = next.aptUnit ?? '';
      }
      if (previous?.city != next.city) {
        _cityController.text = next.city ?? '';
      }
      if (previous?.state != next.state) {
        _stateController.text = next.state ?? '';
      }
      if (previous?.zipCode != next.zipCode) {
        _zipController.text = next.zipCode ?? '';
      }
      if (previous?.emergencyContactName != next.emergencyContactName) {
        _emergencyNameController.text = next.emergencyContactName ?? '';
      }
      if (previous?.emergencyContactPhone != next.emergencyContactPhone) {
        _emergencyPhoneController.text = next.emergencyContactPhone ?? '';
      }
      if (previous?.emergencyContactRelation != next.emergencyContactRelation) {
        _emergencyRelationController.text = next.emergencyContactRelation ?? '';
      }
      if (previous?.emergencyContactEmail != next.emergencyContactEmail) {
        _emergencyEmailController.text = next.emergencyContactEmail ?? '';
      }
      if (previous?.emergencyContactAddress != next.emergencyContactAddress) {
        _emergencyAddressController.text =
            next.emergencyContactAddress ?? '';
      }
      if (previous?.emergencyContactInstructions !=
          next.emergencyContactInstructions) {
        _specialInstructionsController.text =
            next.emergencyContactInstructions ?? '';
      }
    });
    
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
                    maxLength: _maxStreetLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Apt/Unit/Suite',
                    controller: _aptController,
                    maxLength: 20,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'City*',
                    controller: _cityController,
                    maxLength: _maxCityLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'State*',
                    controller: _stateController,
                    maxLength: _maxStateLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Zip Code*',
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    maxLength: _maxZipLength,
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
                    hintText: 'Emergency Contact Name*',
                    controller: _emergencyNameController,
                    maxLength: _maxNameLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Relationship to Child*',
                    controller: _emergencyRelationController,
                    maxLength: _maxRelationLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Primary Phone Number (10 digits)*',
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10, // Exactly 10 digits for US phone numbers
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Email Address',
                    controller: _emergencyEmailController,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: _maxEmailLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Address',
                    controller: _emergencyAddressController,
                    maxLength: _maxAddressLength,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Special Instructions*',
                    controller: _specialInstructionsController,
                    maxLength: _maxInstructionsLength,
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
                if (_streetController.text.trim().isEmpty ||
                    _cityController.text.trim().isEmpty ||
                    _stateController.text.trim().isEmpty ||
                    _zipController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please fill in all required address fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Street Address Length Validation
                if (_streetController.text.trim().length < 2) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Street address must be at least 2 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // City Length Validation
                if (_cityController.text.trim().length < 2) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('City name must be at least 2 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // State Length Validation
                if (_stateController.text.trim().length < 2) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('State must be at least 2 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Zip Code Validation
                final zipRegex = RegExp(r'^\d{5}$');
                if (!zipRegex.hasMatch(_zipController.text.trim())) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter a valid 5-digit Zip Code.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Emergency Contact Name Validation
                if (_emergencyNameController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter emergency contact name.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (_emergencyNameController.text.trim().length < 2) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Emergency contact name must be at least 2 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Relationship Validation
                if (_emergencyRelationController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter relationship to child.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (_emergencyRelationController.text.trim().length < 2) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Relationship must be at least 2 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Phone Number Validation
                if (_emergencyPhoneController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter emergency contact phone number.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!_isValidPhone(_emergencyPhoneController.text)) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter a valid 10-digit phone number.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Email Validation (if provided)
                if (_emergencyEmailController.text.trim().isNotEmpty &&
                    !_isValidEmail(_emergencyEmailController.text.trim())) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter a valid email address.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Special Instructions Validation (Required)
                if (_specialInstructionsController.text.trim().isEmpty) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Please enter special instructions.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (_specialInstructionsController.text.trim().length < 5) {
                  AppToast.show(context,
                    const SnackBar(
                      content: Text('Special instructions must be at least 5 characters.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Format phone number before saving
                final formattedPhone = _formatPhoneNumber(_emergencyPhoneController.text.trim());

                // Save to provider
                ref.read(bookingFlowProvider.notifier).updateStep3(
                      streetAddress: _streetController.text.trim(),
                      aptUnit: _aptController.text.trim().isNotEmpty
                          ? _aptController.text.trim()
                          : null,
                      city: _cityController.text.trim(),
                      addressState: _stateController.text.trim(),
                      zipCode: _zipController.text.trim(),
                      emergencyContactName: _emergencyNameController.text.trim(),
                      emergencyContactPhone: formattedPhone,
                      emergencyContactRelation: _emergencyRelationController.text.trim(),
                      emergencyContactEmail:
                          _emergencyEmailController.text.trim(),
                      emergencyContactAddress:
                          _emergencyAddressController.text.trim(),
                      emergencyContactInstructions:
                          _specialInstructionsController.text.trim(),
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
