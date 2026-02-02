// booking_card.dart
import 'package:babysitter_app/src/features/bookings/presentation/widgets/booking_more_options_sheet.dart';
import 'package:babysitter_app/src/common_widgets/debounced_button.dart';
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
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onMessage,
    required this.onViewDetails,
    required this.onMenuTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTokens.cardBg,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        border: Border.all(color: AppTokens.cardBorder, width: 1),
        boxShadow: AppTokens.cardShadow,
      ),
      padding: const EdgeInsets.all(AppTokens.cardInternalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            booking: booking,
            onMenuTap: onMenuTap,
            onCancel: onCancel,
          ),
          const SizedBox(height: 12),
          RatingRow(rating: booking.rating),
          const SizedBox(height: 12),
          StatRow(
            icon: Icons.schedule_outlined,
            label: 'Response Rate',
            value: '${booking.responseRate}%',
          ),
          const SizedBox(height: 12),
          StatRow(
            icon: Icons.thumb_up_off_alt_outlined,
            label: 'Reliability Rate:',
            value: '${booking.reliabilityRate}%',
          ),
          const SizedBox(height: 12),
          StatRow(
            icon: Icons.settings_outlined,
            label: 'Experience',
            value: booking.experienceText,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: AppTokens.dividerSoft),
          const SizedBox(height: 12),
          _ScheduledRow(booking: booking),
          const SizedBox(height: 14),
          PrimaryButton(label: 'Message', onPressed: onMessage),
          const SizedBox(height: AppTokens.buttonSpacing),
          SecondaryButton(label: 'View Details', onPressed: onViewDetails),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Booking booking;
  final VoidCallback onMenuTap;
  final VoidCallback? onCancel;

  const _Header({
    required this.booking,
    required this.onMenuTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        SizedBox(
          width: AppTokens.avatarSize,
          height: AppTokens.avatarSize,
          child: ClipOval(
            child: _buildAvatar(booking.avatarAssetOrUrl),
          ),
        ),
        const SizedBox(width: 14),

        // Name + distance
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      booking.sitterName,
                      style: AppTokens.cardName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (booking.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      size: 20,
                      color: AppTokens.primaryBlue,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 18, color: AppTokens.primaryBlue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.distanceText,
                      style: AppTokens.cardMeta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Menu
        GestureDetector(
          onTap: () => showBookingMoreOptionsSheet(
            context,
            scheduledDate: booking.scheduledDate,
            onUpdate: () {},
            onCancel: onCancel ?? () {},
            onShare: () {},
          ),
          child: const Icon(Icons.more_vert, color: AppTokens.iconGrey),
        ),
      ],
    );
  }

  Widget _buildAvatar(String assetOrUrl) {
    if (assetOrUrl.startsWith('http')) {
      return Image.network(assetOrUrl, fit: BoxFit.cover);
    }
    return Image.asset(
      assetOrUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.person, color: Colors.grey)),
    );
  }
}

class _ScheduledRow extends StatelessWidget {
  final Booking booking;
  const _ScheduledRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    // EXACT Figma-like: "20 May,2025" (no space after comma)
    final dateText = DateFormat('MM/dd/yyyy').format(booking.scheduledDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Scheduled: $dateText',
            style: AppTokens.scheduledText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        BookingStatusChip(status: booking.status),
      ],
    );
  }
}
