import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_modal_top_bar.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/inset_divider.dart';

class SelectPaymentMethodScreen extends ConsumerWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(
        bookingFlowProvider.select((state) => state.selectedPaymentMethod));

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
                  horizontal: BookingUiTokens.screenHorizontalPadding),
              child: Text(
                'Select Payment Method',
                style: BookingUiTokens.selectionPageTitle,
              ),
            ),

            const SizedBox(height: 26),

            // List Items

            // 1. App balance
            PaymentMethodTile(
              title: 'App balance',
              subtitle: '\$ 700.00',
              icon: Icons.account_balance_wallet_outlined,
              isSelected: selectedMethod == 'App balance',
              onTap: () => onSelectMethod('App balance'),
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 2. Paypal
            PaymentMethodTile(
              title: 'Paypal',
              icon: Icons.paypal,
              isSelected: selectedMethod == 'Paypal',
              onTap: () => onSelectMethod('Paypal'),
              isWhiteDisc: true,
            ),
            const InsetDivider(),

            // 3. Stripe
            PaymentMethodTile(
              title: 'Stripe',
              icon: Icons.credit_card,
              isSelected: selectedMethod == 'Stripe',
              onTap: () => onSelectMethod('Stripe'),
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 4. Apple Pay
            PaymentMethodTile(
              title: 'Apple Pay',
              icon: Icons.apple,
              isSelected: selectedMethod == 'Apple Pay',
              onTap: () => onSelectMethod('Apple Pay'),
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 5. Google Pay
            PaymentMethodTile(
              title: 'Google Pay',
              icon: Icons.g_mobiledata,
              isSelected: selectedMethod == 'Google Pay',
              onTap: () => onSelectMethod('Google Pay'),
              isWhiteDisc: false,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
