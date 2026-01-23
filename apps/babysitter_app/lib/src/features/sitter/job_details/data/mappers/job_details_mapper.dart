import 'package:intl/intl.dart';

import '../../domain/entities/sitter_job_details.dart';
import '../dtos/job_details_response_dto.dart';

/// Mapper to convert API response to domain entity.
class JobDetailsMapper {
  /// Convert API response DTO to domain entity.
  static SitterJobDetails fromDto(JobDetailsResponseDto response) {
    final job = response.data.job;
    final children = response.data.children ?? [];

    // Extract child-specific data (use first child's data for display)
    final firstChild = children.isNotEmpty ? children.first : null;

    // Build personality from child descriptions
    final personality = children
        .where((c) =>
            c.personalityDescription != null &&
            c.personalityDescription!.isNotEmpty)
        .map((c) => c.personalityDescription!)
        .join(', ');

    // Build allergies from child data
    final allergies = children
        .where((c) => c.hasAllergies == true && c.allergyTypes != null)
        .expand((c) => c.allergyTypes!)
        .join(', ');

    // Build triggers from child data
    final triggers = children
        .where((c) => c.triggers != null && c.triggers!.isNotEmpty)
        .map((c) => c.triggers!)
        .join(', ');

    // Build calming methods from child data
    final calmingMethods = children
        .where((c) => c.calmingMethods != null && c.calmingMethods!.isNotEmpty)
        .map((c) => c.calmingMethods!)
        .join(', ');

    // Build transportation modes from first child (usually same for all)
    final transportationModes = firstChild?.transportationModes ?? [];

    // Build equipment/safety from first child
    final equipmentSafety = firstChild?.equipmentSafety ?? [];

    // Build pickup/dropoff details
    final pickupDropoff = <String>[];
    if (firstChild?.pickupLocation != null &&
        firstChild!.pickupLocation!.isNotEmpty) {
      pickupDropoff.add(firstChild.pickupLocation!);
    }
    if (firstChild?.dropoffLocation != null &&
        firstChild!.dropoffLocation!.isNotEmpty) {
      pickupDropoff.add(firstChild.dropoffLocation!);
    }

    // Format distance
    final distanceStr = job.distance != null
        ? '${job.distance!.toStringAsFixed(2)} km away'
        : '';

    return SitterJobDetails(
      id: job.id,
      title: job.title,
      postedTimeAgo: _formatPostedTime(job.createdAt),
      isBookmarked: false,
      familyName: job.familyName ?? 'Family',
      familyAvatarUrl: job.familyPhotoUrl,
      childrenCount: job.childrenCount ?? children.length,
      children: children
          .map((c) => JobChildInfo(name: c.firstName, age: c.age))
          .toList(),
      location: job.location ?? _buildLocationFromAddress(job.address),
      distance: distanceStr,
      dateRange: _formatDateRange(job.startDate, job.endDate),
      timeRange: _formatTimeRange(job.startTime, job.endTime),
      personality: personality.isNotEmpty ? personality : 'Not specified',
      allergies: allergies.isNotEmpty ? allergies : 'None',
      triggers: triggers.isNotEmpty ? triggers : 'None specified',
      calmingMethods:
          calmingMethods.isNotEmpty ? calmingMethods : 'Not specified',
      additionalNotes: job.additionalDetails ?? '',
      transportationModes: transportationModes,
      equipmentSafety: equipmentSafety,
      pickupDropoffDetails: pickupDropoff,
      requiredSkills: [], // Not in current API
      hourlyRate: job.payRate,
    );
  }

  static String _formatPostedTime(String? createdAt) {
    if (createdAt == null) return 'Job posted recently';

    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(createdDate);

      if (difference.inMinutes < 60) {
        return 'Job posted ${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return 'Job posted $hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return 'Job posted $days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        return 'Job posted on ${DateFormat('MM/dd/yyyy').format(createdDate)}';
      }
    } catch (e) {
      return 'Job posted recently';
    }
  }

  static String _formatDateRange(String? startDate, String? endDate) {
    if (startDate == null) return 'Flexible dates';

    try {
      final start = DateTime.parse(startDate);
      final startFormatted = DateFormat('MM/dd/yyyy').format(start);

      if (endDate == null || startDate == endDate) {
        return startFormatted;
      }

      final end = DateTime.parse(endDate);
      final endFormatted = DateFormat('MM/dd/yyyy').format(end);
      return '$startFormatted - $endFormatted';
    } catch (e) {
      return startDate;
    }
  }

  static String _formatTimeRange(String? startTime, String? endTime) {
    if (startTime == null) return 'Flexible time';

    try {
      final startFormatted = _formatTime(startTime);

      if (endTime == null) {
        return startFormatted;
      }

      final endFormatted = _formatTime(endTime);
      return '$startFormatted - $endFormatted';
    } catch (e) {
      return '$startTime - ${endTime ?? ''}';
    }
  }

  static String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return time;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, hour, minute);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return time;
    }
  }

  static String _buildLocationFromAddress(JobAddressDto? address) {
    if (address == null) return '';

    final parts = <String>[];
    if (address.city != null) parts.add(address.city!);
    if (address.state != null) parts.add(address.state!);
    if (address.zipCode != null) parts.add(address.zipCode!);

    return parts.join(', ');
  }
}
