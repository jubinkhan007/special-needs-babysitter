import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/data/providers/booking_flow_provider.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/presentation/theme/booking_ui_tokens.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/presentation/widgets/booking_modal_top_bar.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/presentation/widgets/payment_method_tile.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/presentation/widgets/inset_divider.dart';

class SelectPaymentMethodScreen extends ConsumerWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(
      bookingFlowProvider.select((state) => state.selectedPaymentMethod),
    );

    void onSelectMethod(String method) {
      ref.read(bookingFlowProvider.notifier).updatePaymentMethod(method);
    }

    return Scaffold(
      backgroundColor: BookingUiTokens.pageBackground,
      appBar: BookingModalTopBar(
        title: 'Add Payment Method',
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Main Title
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: BookingUiTokens.screenHorizontalPadding,
              ),
              child: Text(
                'Select Payment Method',
                style: BookingUiTokens.selectionPageTitle,
              ),
            ),

            const SizedBox(height: 26),

            // List Items

            // 1. Credit/Debit Card (Stripe)
            PaymentMethodTile(
              title: 'Credit/Debit Card',
              icon: Icons.credit_card,
              isSelected: selectedMethod == 'Credit/Debit Card',
              onTap: () => onSelectMethod('Credit/Debit Card'),
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 2. Apple Pay
            PaymentMethodTile(
              title: 'Apple Pay',
              icon: Icons.apple,
              isSelected: selectedMethod == 'Apple Pay',
              onTap: () => onSelectMethod('Apple Pay'),
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 3. Google Pay
            PaymentMethodTile(
              title: 'Google Pay',
              icon: Icons.g_mobiledata,
              isSelected: selectedMethod == 'Google Pay',
              onTap: () => onSelectMethod('Google Pay'),
              isWhiteDisc: false,
            ),

            const SizedBox(height: 24),

            // Authorization note
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: BookingUiTokens.screenHorizontalPadding,
              ),
              child: Text(
                'By saving your card, you authorize Special Needs Sitters to securely charge this card for completed bookings.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF667085),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
