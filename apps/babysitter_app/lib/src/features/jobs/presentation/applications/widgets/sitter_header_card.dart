import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';
import '../models/booking_application_ui_model.dart';

class SitterHeaderCard extends StatelessWidget {
  final BookingApplicationUiModel ui;

  const SitterHeaderCard({super.key, required this.ui});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(AppTokens.cardRadius)),
        boxShadow: AppTokens.cardShadow,
      ),
      padding: const EdgeInsets.all(AppTokens.applicationsCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    ui.avatarUrl.isNotEmpty ? NetworkImage(ui.avatarUrl) : null,
                child: ui.avatarUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(ui.sitterName,
                            style: AppTokens.applicationsNameStyle),
                        if (ui.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              size: 16, color: Colors.blue),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Color(0xFF9093A3)),
                        const SizedBox(width: 4),
                        Text(ui.distanceText,
                            style: AppTokens.applicationsMetaStyle),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(ui.ratingText,
                      style: AppTokens.applicationsRatingTextStyle),
                  const SizedBox(width: 12),
                  Icon(Icons.bookmark_border, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCompactStat(
                  Icons.timer_outlined, 'Response Rate', ui.responseRateText),
              _buildCompactStat(Icons.thumb_up_outlined, 'Reliability Rate',
                  ui.reliabilityRateText),
              _buildCompactStat(Icons.verified_user_outlined, 'Experience',
                  ui.experienceText),
            ],
          ),
          const SizedBox(height: 16),

          // Skills Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ui.skills
                .map((skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTint, // Light blue bg
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF9093A3)),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF9093A3))),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTokens.applicationsStatValueStyle),
      ],
    );
  }
}
