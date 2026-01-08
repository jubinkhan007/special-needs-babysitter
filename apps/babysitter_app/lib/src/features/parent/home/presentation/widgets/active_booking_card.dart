import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../models/home_mock_models.dart';
import '../theme/home_design_tokens.dart';

class ActiveBookingCard extends StatelessWidget {
  final BookingModel booking;

  const ActiveBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Active Booking',
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
                    child: Image.asset(
                      booking.sitter.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
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
                              booking.sitter.name,
                              style: HomeDesignTokens.cardTitle,
                            ),
                            const SizedBox(width: 4),
                            if (booking.sitter.isVerified)
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
                            Text(
                              booking.sitter.location, // "2 Miles Away"
                              style: HomeDesignTokens.cardSubtitle,
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
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: AppColors.starYellow),
                          const SizedBox(width: 4),
                          Text(
                            booking.sitter.rating.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 3-dot menu
                      const Icon(Icons.more_horiz,
                          color: AppColors.neutral30, size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Response Rate', '${booking.sitter.responseRate}%',
                      Icons.access_time),
                  _buildStat(
                      'Reliability Rate',
                      '${booking.sitter.reliabilityRate}%',
                      Icons.thumb_up_alt_outlined),
                  _buildStat(
                      'Experience',
                      '${booking.sitter.experienceYears} Years',
                      Icons.verified_outlined),
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
                      'Scheduled: 20 May,2025', // Hardcoded match for screenshot
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
                      color: AppColors.activePillBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.activePillText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active',
                          style: const TextStyle(
                            color: AppColors.activePillText,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.neutral30),
            const SizedBox(width: 4),
            Text(label, style: HomeDesignTokens.statLabel),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: HomeDesignTokens.statValue),
      ],
    );
  }
}
