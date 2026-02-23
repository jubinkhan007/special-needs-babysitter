import 'package:flutter/material.dart';

import 'referral_bonuses_styles.dart';

class InviteSittersCard extends StatelessWidget {
  final String? referralCode;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onCopy;

  const InviteSittersCard({
    super.key,
    required this.referralCode,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ReferralBonusesStyles.cardDecoration,
      padding: const EdgeInsets.all(ReferralBonusesStyles.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invite Sitters', style: ReferralBonusesStyles.cardTitle),
          const SizedBox(height: 6),
          Text(
            'Invite other qualified sitters to join and earn \$10 when they complete their first booking!',
            style: ReferralBonusesStyles.body,
          ),
          const SizedBox(height: 12),
          _buildReferralCodeRow(context),
          const SizedBox(height: 12),
          Text(
            'How It Works:',
            style: ReferralBonusesStyles.value,
          ),
          const SizedBox(height: 8),
          const _BulletItem(text: 'Share your code.'),
          const SizedBox(height: 6),
          const _BulletItem(
            text: 'The referred sitter signs up and completes their first booking.',
          ),
          const SizedBox(height: 6),
          const _BulletItem(text: 'You both receive a \$10 credit!'),
        ],
      ),
    );
  }

  Widget _buildReferralCodeRow(BuildContext context) {
    if (isLoading) {
      return Row(
        children: [
          Text('Referral Code:', style: ReferralBonusesStyles.label),
          const SizedBox(width: 8),
          const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Row(
        children: [
          Expanded(
            child: Text(
              errorMessage!,
              style: ReferralBonusesStyles.label
                  .copyWith(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    final code = referralCode ?? '';

    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'Referral Code: ',
              style: ReferralBonusesStyles.label,
              children: [
                TextSpan(
                  text: code.isNotEmpty ? code : '--',
                  style: ReferralBonusesStyles.value,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.content_copy_outlined),
          color: ReferralBonusesStyles.iconGrey,
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          onPressed: code.isNotEmpty ? onCopy : null,
          tooltip: 'Copy code',
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•', style: ReferralBonusesStyles.body),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: ReferralBonusesStyles.body),
        ),
      ],
    );
  }
}
