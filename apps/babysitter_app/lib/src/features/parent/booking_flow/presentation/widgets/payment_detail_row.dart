import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLargeTotal;

  const PaymentDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isLargeTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label,
            style: BookingUiTokens.rowLabel,
          ),
          const SizedBox(width: 16), // Gap between label and value
          Flexible(
            child: Text(
              value,
              style: isLargeTotal
                  ? BookingUiTokens.totalValue
                  : BookingUiTokens.rowValue,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
