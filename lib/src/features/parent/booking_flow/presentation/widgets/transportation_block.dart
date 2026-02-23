import 'package:flutter/material.dart';

class TransportationBlock extends StatelessWidget {
  final String? transportationMode;
  final String? equipmentSafety;
  final String? pickupDropoffDetails;

  const TransportationBlock({
    super.key,
    this.transportationMode,
    this.equipmentSafety,
    this.pickupDropoffDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Check if all fields are empty
    final hasData = transportationMode != null ||
        equipmentSafety != null ||
        pickupDropoffDetails != null;

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

        if (!hasData)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'No transportation preferences set',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
          )
        else ...[
          if (transportationMode != null && transportationMode!.isNotEmpty)
            _buildRow('Transportation Mode', transportationMode!),
          if (equipmentSafety != null && equipmentSafety!.isNotEmpty)
            _buildRow('Equipment & Safety', equipmentSafety!),
          if (pickupDropoffDetails != null && pickupDropoffDetails!.isNotEmpty)
            _buildRow('Pickup / Drop-off Details', pickupDropoffDetails!),
        ],
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475467),
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
                color: Color(0xFF667085),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
