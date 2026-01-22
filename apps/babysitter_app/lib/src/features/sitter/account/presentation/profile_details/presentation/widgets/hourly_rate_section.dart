import 'package:flutter/material.dart';

class HourlyRateSection extends StatelessWidget {
  final double? hourlyRate;
  final bool? openToNegotiating;
  final VoidCallback? onEditTap;

  const HourlyRateSection({
    super.key,
    this.hourlyRate,
    this.openToNegotiating,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Hourly Rate',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2939),
                ),
              ),
              if (onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Color(0xFF667085),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hourlyRate != null ? '\$${hourlyRate!.toStringAsFixed(0)} / hr' : 'Not set',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF667085),
            ),
          ),
          if (openToNegotiating == true) ...[
            const SizedBox(height: 4),
            const Text(
              'Open to negotiating',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF10B981),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
