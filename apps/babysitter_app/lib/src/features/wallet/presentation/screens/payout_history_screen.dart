import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../widgets/wallet_styles.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WalletStyles.background,
      appBar: AppBar(
        backgroundColor: WalletStyles.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WalletStyles.iconGrey),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterWallet);
            }
          },
        ),
        title: const Text(
          'Payout History',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: WalletStyles.iconGrey,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'No payouts yet',
          style: TextStyle(
            color: WalletStyles.textSecondary,
          ),
        ),
      ),
    );
  }
}
