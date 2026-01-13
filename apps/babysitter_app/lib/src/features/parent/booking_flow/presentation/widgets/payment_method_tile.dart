import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';
import 'pixel_radio.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon; // Placeholder for asset
  final bool isSelected;
  final bool isWhiteDisc;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    required this.isSelected,
    this.isWhiteDisc = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BookingUiTokens.screenHorizontalPadding,
          vertical: 18,
        ),
        child: Row(
          children: [
            // Radio
            PixelRadio(isSelected: isSelected),

            const SizedBox(width: 18),

            // Logo Disc
            Container(
              width: BookingUiTokens.iconDiscSize,
              height: BookingUiTokens.iconDiscSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isWhiteDisc
                    ? BookingUiTokens.logoCircleBgWhite
                    : BookingUiTokens.iconCircleBg,
              ),
              child: Icon(
                icon ?? Icons.credit_card,
                size: 24,
                color: Colors.black87,
              ),
            ),

            const SizedBox(width: 18),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: BookingUiTokens.itemTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: BookingUiTokens.itemSubtitle,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Chevron
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: BookingUiTokens.listChevronGrey,
            ),
          ],
        ),
      ),
    );
  }
}
