import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_top_bar.dart';
import '../widgets/payment_detail_row.dart';
import '../widgets/note_card.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/dashed_divider.dart';
import 'select_payment_method_screen.dart';
import 'service_details_screen.dart';

/// Helper widget to show validation errors
class _ValidationBanner extends StatelessWidget {
  final String message;
  const _ValidationBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD92D20)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFD92D20),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB42318),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentDetailsScreen extends ConsumerWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingFlowProvider);
    final validationError = bookingState.validateAmount();

    return Scaffold(
      backgroundColor: BookingUiTokens.pageBackground,
      appBar: BookingTopBar(
        title: 'Book ${bookingState.sitterName ?? 'Sitter'}',
        onBack: () => Navigator.of(context).pop(),
        onHelp: () {},
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: BookingUiTokens.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Main Title
                const Text(
                  'Payment Details',
                  style: BookingUiTokens.pageTitle,
                ),

                const SizedBox(height: 24),
                
                // Validation Banner
                if (validationError != null)
                  _ValidationBanner(message: validationError),

                const SizedBox(height: 8),

                // Payment Rows
                PaymentDetailRow(
                  label: 'Sub Total',
                  value: '\$ ${bookingState.subTotal.toStringAsFixed(2)}',
                ),
                _buildDashedDivider(),
                PaymentDetailRow(
                  label: 'Total Hours',
                  value: '${bookingState.totalHours.toStringAsFixed(1)} Hours',
                ),
                _buildDashedDivider(),
                PaymentDetailRow(
                  label: 'Hourly Rate',
                  value: '\$ ${bookingState.payRate.toStringAsFixed(2)}/hr',
                ),
                _buildDashedDivider(),
                PaymentDetailRow(
                  label: 'Platform Fee (15%)',
                  value: '\$ ${bookingState.platformFee.toStringAsFixed(2)}',
                ),
                _buildDashedDivider(),
                const PaymentDetailRow(label: 'Discount', value: '\$ 0.00'),
                _buildDashedDivider(),

                const SizedBox(height: 16),
                // Estimated Total
                PaymentDetailRow(
                  label: 'Estimated Total Cost',
                  value: '\$ ${bookingState.totalCost.toStringAsFixed(2)}',
                  isLargeTotal: true,
                ),

                _buildDashedDivider(),

                const SizedBox(height: 32),

                // Note Card
                const NoteCard(),

                // Bottom Spacing to ensure sticky sheet doesn't cover content
                // Sheet height approx 250
                SizedBox(
                  height: 280 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),

          // Sticky Bottom Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PaymentMethodSheet(
              totalCost: bookingState.totalCost,
              isEnabled: validationError == null,
              onChange: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectPaymentMethodScreen(),
                  ),
                );
              },
              onConfirm: validationError == null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ServiceDetailsScreen(),
                        ),
                      );
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(validationError),
                          backgroundColor: const Color(0xFFD92D20),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DashedDivider(),
    );
  }
}
