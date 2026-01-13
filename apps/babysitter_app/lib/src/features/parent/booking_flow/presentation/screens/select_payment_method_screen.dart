import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/booking_modal_top_bar.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/inset_divider.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              isSelected: false,
              onTap: () {},
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 2. Paypal (Selected)
            PaymentMethodTile(
              title: 'Paypal',
              subtitle: '*****doe@gmail.com',
              icon: Icons.paypal, // Needs specific icon, using close match
              isSelected: true,
              onTap: () {},
              isWhiteDisc: true,
            ),
            const InsetDivider(),

            // 3. Square
            PaymentMethodTile(
              title: 'Square',
              subtitle: '*****doe@gmail.com',
              icon: Icons.square,
              isSelected: false,
              onTap: () {},
              isWhiteDisc: true,
            ),
            const InsetDivider(),

            // 4. Credit Card
            PaymentMethodTile(
              title: 'Credit Card Or Debit Card',
              subtitle: '**** **** 1234',
              icon: Icons.credit_card,
              isSelected: false,
              onTap: () {},
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 5. Apple Pay
            PaymentMethodTile(
              title: 'Apple Pay',
              subtitle: '******123',
              icon: Icons.apple,
              isSelected: false,
              onTap: () {},
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 6. Google Pay
            PaymentMethodTile(
              title: 'Google Pay',
              subtitle: '******123',
              icon: Icons.g_mobiledata, // Fallback
              isSelected: false,
              onTap: () {},
              isWhiteDisc: false,
            ),
            const InsetDivider(),

            // 7. Bank Account
            PaymentMethodTile(
              title: 'Bank Account',
              subtitle: '******123',
              icon: Icons.account_balance,
              isSelected: false,
              onTap: () {},
              isWhiteDisc: false,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
