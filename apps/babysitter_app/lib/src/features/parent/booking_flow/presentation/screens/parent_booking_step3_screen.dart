import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../widgets/booking_text_field.dart';
import '../widgets/section_header.dart';
import 'parent_booking_step4_screen.dart';

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
                  ),

                  const SizedBox(height: 24), // Spacing before divider

                  // Divider
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE4E7EC), // Light grey divider
                  ),

                  const SizedBox(height: 24), // Spacing after divider

                  // Section Header: Emergency Contact
                  const SectionHeader(
                    title: 'Emergency Contact',
                    optionalText: '(Optional)',
                  ),

                  const SizedBox(height: 16),

                  // Emergency Fields
                  BookingTextField(
                    hintText: 'Name',
                    controller: _emergencyNameController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Phone Number',
                    controller: _emergencyPhoneController,
                  ),
                  const SizedBox(height: 16),
                  BookingTextField(
                    hintText: 'Relationship',
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
                // Save to provider
                ref.read(bookingFlowProvider.notifier).updateStep3(
                      streetAddress: _streetController.text,
                      aptUnit: _aptController.text.isNotEmpty
                          ? _aptController.text
                          : null,
                      city: _cityController.text,
                      addressState: _stateController.text,
                      zipCode: _zipController.text,
                      emergencyContactName:
                          _emergencyNameController.text.isNotEmpty
                              ? _emergencyNameController.text
                              : null,
                      emergencyContactPhone:
                          _emergencyPhoneController.text.isNotEmpty
                              ? _emergencyPhoneController.text
                              : null,
                      emergencyContactRelation:
                          _emergencyRelationController.text.isNotEmpty
                              ? _emergencyRelationController.text
                              : null,
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
