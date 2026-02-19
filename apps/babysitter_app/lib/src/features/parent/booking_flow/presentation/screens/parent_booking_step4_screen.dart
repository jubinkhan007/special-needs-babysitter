import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import '../widgets/sitter_summary_card.dart';
import '../widgets/summary_kv_row.dart';
import '../widgets/transportation_block.dart';
import 'payment_details_screen.dart';

class ParentBookingStep4Screen extends ConsumerWidget {
  const ParentBookingStep4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingFlowProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      body: Column(
        children: [
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
                  // Sitter Card - Dynamic from provider
                  SitterSummaryCard(
                    name: bookingState.sitterName ?? 'Sitter',
                    avatarUrl: bookingState.sitterAvatarUrl ?? '',
                    rating: bookingState.sitterRating ?? 0.0,
                    distance: bookingState.sitterDistance ?? 'N/A',
                    responseRate: bookingState.sitterResponseRate ?? 'N/A',
                    reliabilityRate:
                        bookingState.sitterReliabilityRate ?? 'N/A',
                    experienceYears: bookingState.sitterExperience ?? 'N/A',
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dashed Divider
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

                  // Dynamic KV List
                  SummaryKvRow(
                    label: 'No. Of Child',
                    value: '${bookingState.selectedChildIds.length}',
                    onEdit: () => _goToStep(context, 1),
                  ),
                  SummaryKvRow(
                    label: 'Child',
                    value: bookingState.selectedChildNames.isNotEmpty
                        ? bookingState.selectedChildNames.join(', ')
                        : 'Not selected',
                    onEdit: () => _goToStep(context, 1),
                  ),
                  SummaryKvRow(
                    label: 'Date',
                    value: bookingState.dateRange ?? 'Not set',
                    onEdit: () => _goToStep(context, 2),
                  ),
                  SummaryKvRow(
                    label: 'No of Days',
                    value: '${bookingState.numberOfDays}',
                    onEdit: () => _goToStep(context, 2),
                  ),
                  SummaryKvRow(
                    label: 'Time',
                    value: bookingState.startTime != null &&
                            bookingState.endTime != null
                        ? '${bookingState.startTime} - ${bookingState.endTime}'
                        : 'Not set',
                    onEdit: () => _goToStep(context, 2),
                  ),
                  SummaryKvRow(
                    label: 'Address',
                    value: bookingState.fullAddress.isNotEmpty
                        ? bookingState.fullAddress
                        : 'Not set',
                    onEdit: () => _goToStep(context, 3),
                    valueAlignment: CrossAxisAlignment.end,
                  ),
                  SummaryKvRow(
                    label: 'Additional Details',
                    value: bookingState.additionalDetails ?? 'None',
                    onEdit: () => _goToStep(context, 1),
                    valueAlignment: CrossAxisAlignment.end,
                  ),

                  const SizedBox(height: 16),

                  // Transportation Block - Dynamic
                  TransportationBlock(
                    transportationMode: bookingState.transportationMode,
                    equipmentSafety: bookingState.equipmentSafety,
                    pickupDropoffDetails: bookingState.pickupDropoffDetails,
                  ),

                  SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom + 60),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.surfaceTint,
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

  void _goToStep(BuildContext context, int step) {
    // Pop back to the specific step
    // For simplicity, we'll just pop. In a real app, you'd use named routes or a flow controller.
    for (int i = 0; i < (4 - step); i++) {
      Navigator.of(context).pop();
    }
  }
}
