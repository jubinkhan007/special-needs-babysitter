import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class TransportPreferencesTable extends StatelessWidget {
  final List<String> modes;
  final List<String> equipment;
  final List<String> pickupDetails;

  const TransportPreferencesTable({
    super.key,
    required this.modes,
    required this.equipment,
    required this.pickupDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow('Transportation Mode', modes),
        const SizedBox(height: 16),
        _buildRow('Equipment & Safety', equipment),
        const SizedBox(height: 16),
        _buildRow('Pickup / Drop-off\nDetails', pickupDetails),
      ],
    );
  }

  Widget _buildRow(String label, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140, // Fixed width for label column
          child: Text(
            label,
            style: AppTokens.transportLabelStyle,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        item,
                        style: AppTokens.transportValueStyle,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
