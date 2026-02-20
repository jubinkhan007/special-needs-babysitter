import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:intl/intl.dart';
import '../../../../bookings/domain/booking.dart';
import '../theme/home_design_tokens.dart';

class ActiveBookingCard extends StatelessWidget {
  final Booking booking;
  final String sectionTitle;
  final String statusLabel;
  final Color? statusBackground;
  final Color? statusTextColor;

  const ActiveBookingCard({
    super.key,
    required this.booking,
    required this.sectionTitle,
    required this.statusLabel,
    this.statusBackground,
    this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = DateFormat('d MMM, yyyy').format(booking.scheduledDate);
    final statusBg = statusBackground ?? AppColors.activePillBg;
    final statusText = statusTextColor ?? AppColors.activePillText;
    final hasAvatar = booking.avatarAssetOrUrl.trim().isNotEmpty;
    final experienceValue = _formatExperience(booking.experienceText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            sectionTitle,
            style: HomeDesignTokens.sectionHeader,
          ),
        ),
        const SizedBox(height: 16),

        // Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(HomeDesignTokens.cardRadius),
            boxShadow: HomeDesignTokens.defaultCardShadow,
          ),
          child: Column(
            children: [
              // Top Row: Avatar + Info + Menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasAvatar
                        ? (booking.avatarAssetOrUrl.startsWith('http')
                            ? Image.network(
                                booking.avatarAssetOrUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox(),
                              )
                            : Image.asset(
                                booking.avatarAssetOrUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox(),
                              ))
                        : const SizedBox(),
                  ),
                  const SizedBox(width: 12),

                  // Name & Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              booking.sitterName,
                              style: HomeDesignTokens.cardTitle,
                            ),
                            const SizedBox(width: 4),
                            if (booking.isVerified)
                              const Icon(Icons.verified,
                                  size: 16, color: AppColors.verifiedBlue),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.neutral30),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.distanceText,
                                style: HomeDesignTokens.cardSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Rating & Menu
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Rating + Menu (same row, menu is vertical and on the right of the star)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: AppColors.starYellow),
                          const SizedBox(width: 4),
                          Text(
                            booking.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.more_vert,
                              color: AppColors.neutral30, size: 20),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStat('Response Rate',
                        '${booking.responseRate}%', Icons.access_time),
                  ),
                  Expanded(
                    child: _buildStat('Reliability Rate',
                        '${booking.reliabilityRate}%', Icons.thumb_up_alt_outlined),
                  ),
                  Expanded(
                    child: _buildStat('Experience',
                        experienceValue, Icons.verified_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.neutral10),
              const SizedBox(height: 12),

              // Bottom Row: Date + Active Pill
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Scheduled: $displayDate',
                      style: const TextStyle(
                        color: AppColors.neutral60,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusText,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right,
                      color: AppColors.neutral40, size: 20),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: AppColors.neutral30),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: HomeDesignTokens.statLabel,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: HomeDesignTokens.statValue),
      ],
    );
  }

  String _formatExperience(String experienceText) {
    final trimmed = experienceText.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'n/a') {
      return 'N/A';
    }
    if (trimmed.toLowerCase().contains('year')) {
      return trimmed;
    }
    return '$trimmed Years';
  }
}
