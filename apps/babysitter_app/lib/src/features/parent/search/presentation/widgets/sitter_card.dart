import 'package:flutter/material.dart';
import '../../models/sitter_list_item_model.dart';
import '../theme/app_ui_tokens.dart';
import 'app_icon_box.dart';
import 'metric_item.dart';
import 'tag_chip.dart';
import 'primary_pill_button.dart';

class SitterCard extends StatelessWidget {
  final SitterListItemModel sitter;
  final VoidCallback onTap;

  const SitterCard({
    super.key,
    required this.sitter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppUiTokens.cardPadding),
      margin:
          const EdgeInsets.symmetric(horizontal: AppUiTokens.horizontalPadding),
      decoration: BoxDecoration(
        color: AppUiTokens.cardBackground,
        borderRadius: BorderRadius.circular(AppUiTokens.radiusLarge),
        boxShadow: AppUiTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header (Avatar, Details, Rating, Bookmark)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipOval(
                child: sitter.imageAssetPath.startsWith('http')
                    ? Image.network(
                        sitter.imageAssetPath,
                        width: AppUiTokens.avatarSize,
                        height: AppUiTokens.avatarSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: AppUiTokens.avatarSize,
                          height: AppUiTokens.avatarSize,
                          color: Colors.grey[200],
                        ),
                      )
                    : Image.asset(
                        sitter.imageAssetPath,
                        width: AppUiTokens.avatarSize,
                        height: AppUiTokens.avatarSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: AppUiTokens.avatarSize,
                          height: AppUiTokens.avatarSize,
                          color: Colors.grey[200],
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Name + Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            sitter.name,
                            style: AppUiTokens.cardName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (sitter.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: AppUiTokens.verifiedBlue,
                            size: AppUiTokens.verifiedIconSize,
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppUiTokens.primaryBlue,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sitter.distanceText,
                            style: AppUiTokens.cardLocation,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppUiTokens.starYellow,
                    size: AppUiTokens.iconSizeMedium,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sitter.rating.toString(),
                    style: AppUiTokens.cardRating,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Bookmark
              AppIconBox(
                icon: Icons.bookmark_border_rounded,
                onTap: () {},
              )
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MetricItem(
                icon: Icons.access_time_filled,
                label: 'Response Rate',
                value: '${sitter.responseRate}%',
              ),
              MetricItem(
                icon: Icons.thumb_up_alt_rounded,
                label: 'Reliability Rate:',
                value: '${sitter.reliabilityRate}%',
              ),
              MetricItem(
                icon: Icons.verified,
                label: 'Experience',
                value: '${sitter.experienceYears} Years',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 3: Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sitter.tags.map((tag) => TagChip(label: tag)).toList(),
          ),
          const SizedBox(height: 16),
          // Row 4: Footer (Price + Button)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${sitter.hourlyRate.toInt()}',
                      style: AppUiTokens.priceValue,
                    ),
                    const TextSpan(
                      text: '/hr',
                      style: AppUiTokens.priceUnit,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryPillButton(
                text: 'View Profile',
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
