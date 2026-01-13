import 'package:flutter/material.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../widgets/sitter_summary_card.dart';
import '../widgets/summary_kv_row.dart';
import '../widgets/transportation_block.dart';
import 'payment_details_screen.dart';

class ParentBookingStep4Screen extends StatelessWidget {
  const ParentBookingStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF), // Light blue background
      body: Column(
        children: [
          // Header
          BookingStepHeader(
            currentStep: 4,
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
                  const SizedBox(height: 8),
                  // Sitter Card
                  const SitterSummaryCard(
                    name: 'Krystina',
                    avatarUrl:
                        'assets/images/placeholder_avatar.png', // Fallback
                    rating: 4.5,
                    distance: '2 Miles Away',
                    responseRate: '95%',
                    reliabilityRate: '95%',
                    experienceYears: '5 Years',
                  ),

                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Divider (Dashed ideally, simple for now)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: List.generate(
                        60,
                        (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0
                                ? const Color(0xFFE4E7EC)
                                : Colors.transparent,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // KV List
                  SummaryKvRow(
                    label: 'No. Of Child',
                    value: '3',
                    onEdit: () {},
                  ),
                  SummaryKvRow(
                    label: 'Date',
                    value: '14 Aug - 17 Aug',
                    onEdit: () {},
                  ),
                  SummaryKvRow(
                    label: 'No of Days',
                    value: '4',
                    onEdit: () {},
                  ),
                  SummaryKvRow(
                    label: 'Time',
                    value: '09 AM - 06 PM',
                    onEdit: () {},
                  ),
                  SummaryKvRow(
                    label: 'Address',
                    value:
                        '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna',
                    onEdit: () {},
                    valueAlignment: CrossAxisAlignment.end,
                  ),
                  SummaryKvRow(
                    label: 'Additional Details',
                    value:
                        'My son is sensitive to loud noises, so please keep a calm and quiet environment.',
                    onEdit: () {},
                    valueAlignment: CrossAxisAlignment.end,
                  ),

                  const SizedBox(height: 16),
                  const TransportationBlock(),

                  // Bottom spacing for sticky button
                  SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom + 60),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            color: const Color(0xFFF0F9FF),
            padding: EdgeInsets.fromLTRB(
                24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
            child: BookingPrimaryBottomButton(
              text: 'Next',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentDetailsScreen(),
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
