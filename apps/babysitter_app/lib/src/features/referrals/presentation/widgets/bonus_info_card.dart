import 'package:flutter/material.dart';

import 'referral_bonuses_styles.dart';

class BonusInfoCard extends StatelessWidget {
  final String title;
  final String description;

  const BonusInfoCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ReferralBonusesStyles.cardDecoration,
      padding: const EdgeInsets.all(ReferralBonusesStyles.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ReferralBonusesStyles.cardTitle),
          const SizedBox(height: 8),
          Text(description, style: ReferralBonusesStyles.body),
        ],
      ),
    );
  }
}
