import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class PixelRadio extends StatelessWidget {
  final bool isSelected;

  const PixelRadio({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BookingUiTokens.radioSize,
      height: BookingUiTokens.radioSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? BookingUiTokens.radioSelectedOuterBlue
              : BookingUiTokens.radioOuterGrey,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: BookingUiTokens.radioSelectedInnerBlue,
                ),
              ),
            )
          : null,
    );
  }
}
