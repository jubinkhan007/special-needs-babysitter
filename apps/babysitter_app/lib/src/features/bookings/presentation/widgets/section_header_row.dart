import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_status.dart';
import 'booking_status_chip.dart';

class SectionHeaderRow extends StatelessWidget {
  final String title;
  final BookingStatus? status; // Optional status to show chip

  const SectionHeaderRow({
    super.key,
    required this.title,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24), // Space below header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTokens.sectionTitle),
          if (status != null) BookingStatusChip(status: status!),
        ],
      ),
    );
  }
}
