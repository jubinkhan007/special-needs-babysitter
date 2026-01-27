// booking_status_chip.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_status.dart';

class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;
  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color dot;
    late final String text;

    switch (status) {
      case BookingStatus.active:
        bg = AppTokens.chipBlueBg;
        dot = AppTokens.chipBlueDot;
        text = 'Active';
        break;
      case BookingStatus.clockedOut:
        bg = AppTokens.chipBlueBg;
        dot = AppTokens.chipBlueDot;
        text = 'Clocked out';
        break;
      case BookingStatus.upcoming:
        bg = AppTokens.chipGreenBg;
        dot = AppTokens.chipGreenDot;
        text = 'Upcoming';
        break;
      case BookingStatus.pending:
        bg = AppTokens.chipOrangeBg;
        dot = AppTokens.chipOrangeDot;
        text = 'Pending';
        break;
      case BookingStatus.completed:
        bg = AppTokens.chipPurpleBg;
        dot = AppTokens.chipPurpleDot;
        text = 'Completed';
        break;
      case BookingStatus.cancelled:
        bg = AppTokens.chipGreyBg;
        dot = AppTokens.chipGreyDot;
        text = 'Cancelled';
        break;
    }

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          Text(text, style: AppTokens.chipText),
        ],
      ),
    );
  }
}
