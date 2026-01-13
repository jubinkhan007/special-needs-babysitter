import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_top_bar.dart';
import '../widgets/payment_detail_row.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/dashed_divider.dart';
import 'booking_request_sent_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

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
                  'Service Details',
                  style: BookingUiTokens.pageTitle,
                ),

                const SizedBox(height: 8),
                _buildDashedDivider(),
                const SizedBox(height: 4),

                // Service Data Rows
                const PaymentDetailRow(label: 'No. Of Child', value: '3'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Date', value: '14 Aug - 17 Aug'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'No of Days', value: '4'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Job Type', value: 'Part Time'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Time', value: '09 AM - 06 PM'),
                _buildRowGap(),
                const PaymentDetailRow(
                    label: 'Address',
                    value:
                        '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna'),

                const SizedBox(height: 24),
                _buildDashedDivider(),
                const SizedBox(height: 8),

                // Cost Breakdown
                const PaymentDetailRow(label: 'Sub Total', value: '\$ 300'),
                _buildRowGap(),
                _buildDashedDivider(),
                _buildRowGap(),

                const PaymentDetailRow(label: 'Total Hours', value: '40 Hours'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Hourly Rate', value: '\$ 20/hr'),
                _buildRowGap(),
                _buildDashedDivider(),
                _buildRowGap(),

                const PaymentDetailRow(label: 'Platform Fee', value: '\$ 20'),
                _buildRowGap(),
                const PaymentDetailRow(label: 'Discount', value: '\$ 0'),

                // Bottom Spacing for Sticky Sheet
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
              ctaLabel: 'Submit',
              onChange: () {
                // Change payment method logic
              },
              onConfirm: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BookingRequestSentScreen(),
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
      padding: EdgeInsets.symmetric(vertical: 4),
      child: DashedDivider(),
    );
  }

  Widget _buildRowGap() {
    return const SizedBox(height: 4);
  }
}
