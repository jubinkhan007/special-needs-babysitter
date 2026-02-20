import 'package:flutter/material.dart';
import '../../../sitter_profile/presentation/widgets/chip_pill.dart';

class SitterSummaryCard extends StatelessWidget {
  final String name;
  final String avatarUrl; // In real app, this would use NetworkImage
  final double rating;
  final String distance;
  final bool isVerified;
  final String responseRate;
  final String reliabilityRate;
  final String experienceYears;

  const SitterSummaryCard({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.distance,
    this.isVerified = true,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceYears,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: avatarUrl.startsWith('http')
                        ? NetworkImage(avatarUrl)
                        : AssetImage(avatarUrl) as ImageProvider,
                    fit: BoxFit.cover,
                    onError: (_, _) {
                      // Error handling is done by the child Icon fallback if image fails to load
                      // But DecorationImage doesn't propagate errors nicely to 'child'
                      // For a robust solution, we might want to use cached_network_image package
                      // For now, we rely on the placeholder if the url is empty/invalid
                    },
                  ),
                ),
                // Fallback icon for demo if asset missing or failed
                child: avatarUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),

              // Name & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF101828),
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: Color(0xFF2E90FA), // Brand blue
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF667085),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF667085),
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
                    size: 18,
                    color: Color(0xFFFAC515), // Yellow
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Bookmark
              const Icon(
                Icons.bookmark_border,
                size: 24,
                color: Color(0xFF98A2B3),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(
                icon: Icons.timer_outlined,
                label: 'Response Rate',
                value: responseRate,
              ),
              _buildMetricItem(
                icon: Icons.thumb_up_outlined,
                label: 'Reliability Rate',
                value: reliabilityRate,
              ),
              _buildMetricItem(
                icon: Icons.workspace_premium_outlined, // Badge/Medal
                label: 'Experience',
                value: experienceYears,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chips
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipPill(label: 'CPR'),
              ChipPill(label: 'First-aid'),
              ChipPill(label: 'Special Needs Training'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF667085)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10, // Small label
                fontWeight: FontWeight.w500,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101828),
          ),
        ),
      ],
    );
  }
}
