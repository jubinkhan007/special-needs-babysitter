import 'package:flutter/material.dart';

class WillingToTravelSection extends StatelessWidget {
  final bool willingToTravel;
  final bool overnightStay;
  final ValueChanged<bool> onWillingChanged;
  final ValueChanged<bool> onOvernightChanged;

  const WillingToTravelSection({
    super.key,
    required this.willingToTravel,
    required this.overnightStay,
    required this.onWillingChanged,
    required this.onOvernightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Willing to Travel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCheckbox(
                label: 'Yes',
                value: willingToTravel,
                onChanged: onWillingChanged,
              ),
            ),
            Expanded(
              child: _buildCheckbox(
                label: 'Overnight',
                value: overnightStay,
                onChanged: onOvernightChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color:
                      value ? const Color(0xFF88CBE6) : const Color(0xFF98A2B3),
                  width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: value
                ? const Icon(Icons.check, size: 18, color: Color(0xFF88CBE6))
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}
