import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_top_bar.dart';
import '../widgets/payment_detail_row.dart';
import '../widgets/note_card.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/dashed_divider.dart';
import 'select_payment_method_screen.dart';
import 'service_details_screen.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingUiTokens.pageBackground,
      appBar: BookingTopBar(
        title: 'Book Krystina',
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

                const SizedBox(height: 32),

                // Payment Rows
                const PaymentDetailRow(label: 'Sub Total', value: '\$ 300'),
                _buildDashedDivider(),
                const PaymentDetailRow(label: 'Total Hours', value: '40 Hours'),
                _buildDashedDivider(),
                const PaymentDetailRow(label: 'Hourly Rate', value: '\$ 20/hr'),
                _buildDashedDivider(),
                const PaymentDetailRow(label: 'Platform Fee', value: '\$ 20'),
                _buildDashedDivider(),
                const PaymentDetailRow(label: 'Discount', value: '\$ 0'),
                _buildDashedDivider(),

                const SizedBox(height: 16),
                // Estimated Total
                const PaymentDetailRow(
                  label: 'Estimated Total Cost',
                  value: '\$ 320',
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
              onChange: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectPaymentMethodScreen(),
                  ),
                );
              },
              onConfirm: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ServiceDetailsScreen(),
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
