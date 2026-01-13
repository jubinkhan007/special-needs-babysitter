import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking.dart';
import 'booking_status_chip.dart';
import 'primary_button.dart';
import 'rating_row.dart';
import 'secondary_button.dart';
import 'stat_row.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onMessage;
  final VoidCallback onViewDetails;
  final VoidCallback onMenuTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onMessage,
    required this.onViewDetails,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTokens.cardBg,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        border: Border.all(color: AppTokens.cardBorder, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: AppTokens.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppTokens.cardInternalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              SizedBox(
                width: AppTokens.avatarSize,
                height: AppTokens.avatarSize,
                child: Stack(
                  children: [
                    Container(
                      width: AppTokens.avatarSize,
                      height: AppTokens.avatarSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE0E0E0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildAvatar(booking.avatarAssetOrUrl),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Name & Distance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Text(booking.sitterName,
                                style: AppTokens.cardName)),
                        if (booking.isVerified) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.verified,
                              size: 20, color: AppTokens.primaryBlue),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: AppTokens.primaryBlue),
                        const SizedBox(width: 4),
                        Text(booking.distanceText, style: AppTokens.cardMeta),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu
              GestureDetector(
                onTap: onMenuTap,
                child: const Icon(Icons.more_vert, color: AppTokens.iconGrey),
              ),
            ],
          ),

          SizedBox(height: AppTokens.cardVerticalGap),

          // Rating
          RatingRow(rating: booking.rating),

          SizedBox(height: AppTokens.cardVerticalGap),

          // Stats
          StatRow(
              icon: Icons.access_time,
              label: 'Response Rate',
              value: '${booking.responseRate}%'),
          SizedBox(height: AppTokens.cardVerticalGap),
          StatRow(
              icon: Icons.thumb_up_alt_outlined,
              label: 'Reliability Rate',
              value: '${booking.reliabilityRate}%'),
          SizedBox(height: AppTokens.cardVerticalGap),
          StatRow(
              icon: Icons.stars_outlined,
              label: 'Experience',
              value: booking.experienceText),

          SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: AppTokens.cardBorder),
          SizedBox(height: 16),

          // Scheduled
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scheduled: ${DateFormat('dd May,yyyy').format(booking.scheduledDate)}', // Mapped format to Figma example "20 May,2025"
                style: AppTokens.scheduledText,
              ),
              BookingStatusChip(status: booking.status),
            ],
          ),

          SizedBox(height: 20),

          // Buttons
          PrimaryButton(label: 'Message', onPressed: onMessage),
          SizedBox(height: AppTokens.buttonSpacing),
          SecondaryButton(label: 'View Details', onPressed: onViewDetails),
        ],
      ),
    );
  }

  Widget _buildAvatar(String assetOrUrl) {
    if (assetOrUrl.startsWith('http')) {
      return Image.network(assetOrUrl, fit: BoxFit.cover);
    }
    return Image.asset(assetOrUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, color: Colors.grey));
  }
}
