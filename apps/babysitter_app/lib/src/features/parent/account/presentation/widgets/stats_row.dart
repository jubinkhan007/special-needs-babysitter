import 'package:flutter/material.dart';
import '../account_ui_constants.dart';

class StatsRow extends StatelessWidget {
  final int bookingCount;
  final int savedSitterCount;
  final VoidCallback onTapBookings;
  final VoidCallback onTapSaved;

  const StatsRow({
    super.key,
    required this.bookingCount,
    required this.savedSitterCount,
    required this.onTapBookings,
    required this.onTapSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Booking History',
            count: bookingCount,
            onTap: onTapBookings,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Saved Sitters',
            count: savedSitterCount,
            onTap: onTapSaved,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const _StatCard({
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, // Fixed height to match design roughly
        decoration: AccountUI.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AccountUI.textDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: AccountUI.subtitleStyle.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: AccountUI.textGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
