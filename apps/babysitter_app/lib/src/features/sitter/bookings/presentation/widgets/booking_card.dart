import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../data/models/booking_model.dart';

/// Card widget displaying a single booking.
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  String _formatTimeDisplay() {
    final startDateTime = _parseStartDateTime();
    final isToday = startDateTime != null
        ? _isToday(startDateTime)
        : booking.isToday;
    final hoursUntilStart = startDateTime != null
        ? _hoursUntilStart(startDateTime)
        : booking.hoursUntilStart;

    if (isToday && hoursUntilStart != null) {
      final hours = hoursUntilStart;
      if (hours < 1) {
        final minutes = (hours * 60).round();
        return 'Job Starting in $minutes Minutes';
      } else {
        final hoursInt = hours.floor();
        return 'Job Starting in $hoursInt Hour${hoursInt > 1 ? 's' : ''}';
      }
    }
    return '';
  }

  DateTime? _parseStartDateTime() {
    final date = _parseDate(booking.startDate);
    final minutes = _parseTimeToMinutes(booking.startTime);
    if (date == null || minutes == null) {
      return null;
    }
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    try {
      final parsed = DateTime.parse(trimmed);
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      final parts = trimmed.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final first = int.tryParse(parts[0]);
        final second = int.tryParse(parts[1]);
        final third = int.tryParse(parts[2]);
        if (first == null || second == null || third == null) {
          return null;
        }
        if (parts[0].length == 4) {
          return DateTime(first, second, third);
        }
        final year = third < 100 ? 2000 + third : third;
        return DateTime(year, first, second);
      }
    }
    return null;
  }

  int? _parseTimeToMinutes(String value) {
    try {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }

      final lower = trimmed.toLowerCase();
      final isAm = lower.contains('am');
      final isPm = lower.contains('pm');
      final sanitized = lower.replaceAll(RegExp(r'[^0-9:]'), '');
      if (sanitized.isEmpty) {
        return null;
      }

      final parts = sanitized.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (minute < 0 || minute > 59) {
        return null;
      }

      var adjustedHour = hour;
      if (isPm && adjustedHour < 12) {
        adjustedHour += 12;
      }
      if (isAm && adjustedHour == 12) {
        adjustedHour = 0;
      }
      if (!isAm && !isPm && (adjustedHour < 0 || adjustedHour > 23)) {
        return null;
      }

      return adjustedHour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  double _hoursUntilStart(DateTime startDateTime) {
    final now = DateTime.now();
    final minutes = startDateTime.difference(now).inMinutes;
    final clampedMinutes = minutes < 0 ? 0 : minutes;
    return clampedMinutes / 60.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeDisplay = _formatTimeDisplay();
    final startDateTime = _parseStartDateTime();
    final isToday =
        startDateTime != null ? _isToday(startDateTime) : booking.isToday;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with bookmark icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: AppColors.textTertiary,
                    size: 24,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalSm,

            // Family name with icon
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${booking.familyName} (${booking.childrenCount} ${booking.childrenCount == 1 ? 'Child' : 'Children'})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalXs,

            // Location with icon
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.distance != null
                        ? '${booking.location} (${booking.distance!.toStringAsFixed(1)} km away)'
                        : booking.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalMd,

            // Pay rate and status row
            Row(
              children: [
                // Pay rate
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$${booking.payRate.toInt()}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '/hr',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Time status badges
                if (isToday) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Today',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (timeDisplay.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        timeDisplay,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ] else if (timeDisplay.isNotEmpty) ...[
                  Expanded(
                    child: Text(
                      timeDisplay,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            AppSpacing.verticalMd,

            // View Details button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF89CFF0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Details',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
