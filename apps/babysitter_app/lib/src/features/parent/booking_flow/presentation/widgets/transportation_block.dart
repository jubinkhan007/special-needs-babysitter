import 'package:flutter/material.dart';

class TransportationBlock extends StatelessWidget {
  const TransportationBlock({super.key});

  @override
  Widget build(BuildContext context) {
    // Reusing the style from SummaryKvRow but for grouped content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        RichText(
          text: const TextSpan(
            text: 'Transportation Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
              fontFamily: 'Instrument Sans',
            ),
            children: [
              TextSpan(text: ' '),
              TextSpan(
                text: '(Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildRow(
          'Transportation Mode',
          'No transportation (care at home only)\nWalking only (short distance)\nFamily vehicle with car seat provided\nRide-share allowed (with parent consent)',
        ),
        _buildRow(
          'Equipment & Safety',
          'Car seat required\nBooster seat required',
        ),
        _buildRow(
          'Pickup / Drop-off Details',
          'Sunshine Elementary School, Gate 3\nHome — 42 Greenview Avenue, Apt 5B\nPick up at the school gate only. Please avoid using highways as my child gets motion sickness.',
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize:
                    14, // Slightly smaller/different weight than main list? Figma looks similar but maybe bolder
                fontWeight: FontWeight.w600, // Semibold for these headers
                color: Color(0xFF475467), // Darker grey
              ),
            ),
          ),

          // Value
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085), // Grey text
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
