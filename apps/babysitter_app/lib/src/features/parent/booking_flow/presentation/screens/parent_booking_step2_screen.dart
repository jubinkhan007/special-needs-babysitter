import 'package:flutter/material.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../widgets/booking_text_field.dart';
import '../widgets/booking_date_range_field.dart';
import '../widgets/booking_time_field.dart';
import 'parent_booking_step3_screen.dart';

class ParentBookingStep2Screen extends StatefulWidget {
  const ParentBookingStep2Screen({super.key});

  @override
  State<ParentBookingStep2Screen> createState() =>
      _ParentBookingStep2ScreenState();
}

class _ParentBookingStep2ScreenState extends State<ParentBookingStep2Screen> {
  final TextEditingController _jobTitleController = TextEditingController();

  // Mock State
  String? _dateRangeText =
      "14-08-2025- 17-08-2025"; // Pre-filled to match screenshot
  String? _startTime;
  String? _endTime;

  @override
  void dispose() {
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // Light blue background
      body: Column(
        children: [
          // Header (Handles its own top safe area)
          BookingStepHeader(
            currentStep: 2,
            totalSteps: 4,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () {},
          ),

          // Progress Indicator IS INSIDE HEADER NOW, removing duplicate.

          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title found in screenshot "Job Details"
                  // Spacing between progress and title
                  const SizedBox(
                      height: 0), // Progress indicator has tight spacing?
                  // Screenshot shows significant gap. Let's look at Step 1.
                  // Step 1 had 24 gap.
                  // The "Progress Indicator" widget has 24 height.

                  const Text(
                    'Job Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Job Title Field
                  BookingTextField(
                    hintText: 'Job Title*',
                    controller: _jobTitleController,
                  ),
                  const SizedBox(height: 16),

                  // Date Range Field
                  BookingDateRangeField(
                    value: _dateRangeText,
                    onTap: () {
                      // Open Date Picker
                    },
                  ),
                  const SizedBox(height: 16),

                  // Time Row
                  Row(
                    children: [
                      Expanded(
                        child: BookingTimeField(
                          hintText: 'Start Time*',
                          value: _startTime,
                          onTap: () {
                            // Open Time Picker
                          },
                        ),
                      ),
                      const SizedBox(width: 16), // Gap between time fields
                      Expanded(
                        child: BookingTimeField(
                          hintText: 'End Time*',
                          value: _endTime,
                          onTap: () {
                            // Open Time Picker
                          },
                        ),
                      ),
                    ],
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentBookingStep3Screen(),
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
