import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../theme/booking_ui_tokens.dart';

class PaymentMethodSheet extends ConsumerWidget {
  final VoidCallback? onChange;
  final VoidCallback onConfirm;
  final String ctaLabel;
  final double totalCost;
  final bool showChange;
  final bool isEnabled;

  const PaymentMethodSheet({
    super.key,
    this.onChange,
    required this.onConfirm,
    this.ctaLabel = 'Confirm Payment & Address',
    required this.totalCost,
    this.showChange = true,
    this.isEnabled = true,
  });

  IconData _getIconForMethod(String method) {
    switch (method) {
      case 'App balance':
        return Icons.account_balance_wallet_outlined;
      case 'Paypal':
        return Icons.paypal;
      case 'Stripe':
        return Icons.credit_card;
      case 'Apple Pay':
        return Icons.apple;
      case 'Google Pay':
        return Icons.g_mobiledata;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(
        bookingFlowProvider.select((state) => state.selectedPaymentMethod));

    return Container(
      decoration: const BoxDecoration(
        color: BookingUiTokens.bottomSheetBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: BookingUiTokens.dashedLineColor,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        18,
        24,
        MediaQuery.of(context).padding.bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: BookingUiTokens.primaryText,
                ),
              ),
              if (showChange && onChange != null)
                GestureDetector(
                  onTap: onChange,
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: BookingUiTokens.iconGrey,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Selected Payment Method Row
          Row(
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(_getIconForMethod(selectedMethod),
                    color: Colors.blue, size: 28),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Text(
                  selectedMethod,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: BookingUiTokens.primaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Amount
              Text(
                '\$ ${totalCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: BookingUiTokens.primaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 60, // Large button
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? BookingUiTokens.primaryButtonBg
                    : const Color(0xFFD0D5DD),
                foregroundColor: BookingUiTokens.ctaButtonText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isEnabled ? ctaLabel : 'Invalid Amount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
