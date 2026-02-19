import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../models/referral_item.dart';
import '../../utils/referral_formatters.dart';
import 'referral_bonuses_styles.dart';

class RewardRow extends StatelessWidget {
  final ReferralItem referral;

  const RewardRow({
    super.key,
    required this.referral,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = _displayName();
    final joinedDate = _joinedDate();
    final amountText = formatUsdFromCents(referral.earnedAmountCents);
    final avatarUrl = referral.referredUserAvatarUrl ?? '';
    final hasAvatar = avatarUrl.startsWith('http');

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surfaceTint,
          backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
          child: hasAvatar
              ? null
              : const Icon(
                  Icons.person,
                  size: 18,
                  color: ReferralBonusesStyles.iconGrey,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: ReferralBonusesStyles.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Joined: $joinedDate',
                style: ReferralBonusesStyles.label,
              ),
            ],
          ),
        ),
        Text(
          amountText,
          style: ReferralBonusesStyles.value,
        ),
      ],
    );
  }

  String _displayName() {
    final name = referral.referredUserName;
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }

    final id = referral.referredUserId ?? referral.id;
    if (id.isNotEmpty) {
      final last4 = id.length > 4 ? id.substring(id.length - 4) : id;
      return 'Sitter $last4';
    }

    return 'Referred Sitter';
  }

  String _joinedDate() {
    final date = referral.signedUpAt ?? referral.createdAt;
    return formatShortDate(date);
  }
}
