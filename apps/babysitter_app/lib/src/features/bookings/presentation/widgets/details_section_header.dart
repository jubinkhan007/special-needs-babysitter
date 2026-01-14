import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class DetailsSectionHeader extends StatelessWidget {
  final String title;

  const DetailsSectionHeader({
    super.key,
    this.title = 'Service Details',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTokens.activeSectionTitle,
        ),
        _buildActiveChip(),
      ],
    );
  }

  Widget _buildActiveChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.chipBlueBg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTokens.chipBlueDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Active',
            style: AppTokens.chipText,
          ),
        ],
      ),
    );
  }
}
