import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class InsetDivider extends StatelessWidget {
  const InsetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    // Divider inset left = PADDING(24) + RADIO(20) + GAP(18) + DISC(48) + GAP(18)
    // = 128
    const double inset = 128.0;

    return const Divider(
      height: 1,
      thickness: 1,
      indent: inset,
      color: BookingUiTokens.dividerColor,
    );
  }
}
