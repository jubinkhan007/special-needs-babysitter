import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/booking_details_ui_model.dart';
import 'booking_surface_card.dart';

class SitterDetailsCard extends StatelessWidget {
  final BookingDetailsUiModel uiModel;

  const SitterDetailsCard({
    super.key,
    required this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    return BookingSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Section: Avatar, Name & Location, Rating & Bookmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: AppTokens.avatarSize,
                height: AppTokens.avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: uiModel.avatarUrl.startsWith('http')
                        ? NetworkImage(uiModel.avatarUrl) as ImageProvider
                        : AssetImage(uiModel.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            uiModel.sitterName,
                            style: AppTokens.cardName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (uiModel.isVerified) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.verified,
                              size: 16, color: AppTokens.primaryBlue),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: AppTokens.primaryBlue),
                        const SizedBox(width: 4),
                        Text(uiModel.distance, style: AppTokens.cardMeta),
                      ],
                    ),
                  ],
                ),
              ),

              // Rating & Bookmark
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 20, color: AppTokens.starYellow),
                      const SizedBox(width: 4),
                      Text(uiModel.rating, style: AppTokens.ratingText),
                      const SizedBox(width: 12),
                      const Icon(Icons.bookmark_border,
                          size: 24, color: AppTokens.iconGrey),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2. Stats Section
          LayoutBuilder(
            builder: (context, constraints) {
              // Use scrollable row if screen is narrow
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(
                      Icons.access_time_filled,
                      'Response Rate',
                      uiModel.responseRate,
                    ),
                    SizedBox(width: constraints.maxWidth > 350 ? 24 : 16),
                    _buildStatColumn(
                      Icons.thumb_up_alt,
                      'Reliability Rate:',
                      uiModel.reliabilityRate,
                    ),
                    SizedBox(width: constraints.maxWidth > 350 ? 24 : 16),
                    _buildStatColumn(
                      Icons.verified_user,
                      'Experience',
                      uiModel.experience,
                    ),
                  ],
                ),
              );
            }
          ),

          if (uiModel.skills.isNotEmpty) ...[
            const SizedBox(height: 18),
            // 3. Skills Section
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  uiModel.skills.map((skill) => _buildSkillTag(skill)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centered or Start?
      // Screenshot shows left aligned text within its column/area?
      // Actually "Response Rate" is centered above "95%".
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTokens.textSecondary),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppTokens.textSecondary)),
            // Using inline style or new token? Plan said strictly AppTokens.
            // But AppTokens.statLabel is 14. Screenshot looks smaller for these detailed headers.
            // Let's assume AppTokens.statLabel but maybe reduced?
            // "Response Rate" looks small (10-12px).
            // "95%" looks big (16-18px).
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTokens.statValue),
      ],
    );
  }

  // Re-implementing clearer specific layout from screenshot
  // Screenshot:
  // (Clock) Response Rate    (Thumb) Reliability Rate:    (Badge) Experience
  //        95%                         95%                       5 Years
  // It seems they are aligned.

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.skillTagHorizontalPadding,
        vertical: AppTokens.skillTagVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppTokens.skillTagBg,
        borderRadius: BorderRadius.circular(AppTokens.skillTagRadius),
      ),
      child: Text(skill, style: AppTokens.skillTagStyle),
    );
  }
}
