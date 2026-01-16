import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';
import '../models/application_item_ui_model.dart';
import 'application_status_chip.dart';
import 'application_actions.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationItemUiModel ui;
  final VoidCallback onAccept;
  final VoidCallback onViewApplication;
  final VoidCallback onReject;
  final VoidCallback onMoreOptions;
  final VoidCallback? onCardTap;

  const ApplicationCard({
    super.key,
    required this.ui,
    required this.onAccept,
    required this.onViewApplication,
    required this.onReject,
    required this.onMoreOptions,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppTokens.cardRadius)),
          boxShadow: AppTokens.cardShadow,
        ),
        padding: const EdgeInsets.all(AppTokens.applicationsCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Avatar + Name + Distance + Kebab)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: ui.avatarUrl.isNotEmpty
                      ? NetworkImage(ui.avatarUrl)
                      : null,
                  child: ui.avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),

                // Name & Distance
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ui.sitterName,
                            style: AppTokens.applicationsNameStyle,
                          ),
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
                          Text(
                            ui.distanceText,
                            style: AppTokens.applicationsMetaStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Kebab
                GestureDetector(
                  onTap: onMoreOptions,
                  child: const Icon(Icons.more_vert, color: Color(0xFF9093A3)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Rating Row
            Row(
              children: [
                // Star Rating Builder
                ...List.generate(5, (index) {
                  return Icon(
                    index < ui.ratingValue.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFFFC107), // Amber/Yellow
                    size: 18,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  ui.ratingText,
                  style: AppTokens.applicationsRatingTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Stats Rows
            _buildStatRow(
              icon: Icons.timer_outlined,
              label: 'Response Rate',
              value: ui.responseRateText,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              icon: Icons.thumb_up_outlined,
              label: 'Reliability Rate:',
              value: ui.reliabilityRateText,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              icon: Icons.verified_user_outlined, // Badge icon
              label: 'Experience',
              value: ui.experienceText,
            ),
            const SizedBox(height: 16),

            // 4. Divider
            const Divider(
              color: AppTokens.applicationsInnerDividerColor,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),

            // 5. Job Info Block
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ui.jobTitle,
                      style: AppTokens.applicationsJobTitleStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ui.scheduledDateText,
                      style: AppTokens.applicationsScheduledStyle,
                    ),
                  ],
                ),
                if (ui.showApplicationChip) const ApplicationStatusChip(),
              ],
            ),
            const SizedBox(height: 16),

            // 6. Buttons or Status
            if (ui.isPending)
              ApplicationActions(
                onAccept: onAccept,
                onViewApplication: onViewApplication,
                onReject: onReject,
              )
            else
              _buildStatusLabel(ui.status ?? 'processed'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF9093A3)), // Grey icon
            const SizedBox(width: 8),
            Text(label, style: AppTokens.applicationsStatLabelStyle),
          ],
        ),
        Text(value, style: AppTokens.applicationsStatValueStyle),
      ],
    );
  }

  Widget _buildStatusLabel(String status) {
    Color bgColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'accepted':
        bgColor = const Color(0xFFE8F5E9); // Light green
        textColor = const Color(0xFF2E7D32); // Dark green
        displayText = 'Accepted';
        break;
      case 'rejected':
      case 'declined':
        bgColor = const Color(0xFFFFEBEE); // Light red
        textColor = const Color(0xFFC62828); // Dark red
        displayText = 'Rejected';
        break;
      default:
        bgColor = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF757575);
        displayText = status.toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
