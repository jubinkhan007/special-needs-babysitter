import 'booking_status.dart';

class ActiveBookingDetails {
  final String bookingId;
  final String sitterId;
  final String sitterName;
  final String sitterAvatarUrl;
  final bool isSitterVerified;
  final double rating;
  final double distanceMiles;

  // Sitter Stats
  final int responseRatePercent;
  final int reliabilityRatePercent;
  final int experienceYears;

  final List<String> skillTags;

  // Live Tracking
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  // In real app, polyline points list

  // Service Details
  final String familyName;
  final int numberOfChildren;
  final DateTime dateStart;
  final DateTime dateEnd;
  final DateTime timeStart; // Only time component matters
  final DateTime timeEnd; // Only time component matters
  final double hourlyRate;
  final int numberOfDays;
  final String additionalNotes;
  final List<String> addressLines;

  final BookingStatus status;

  const ActiveBookingDetails({
    required this.bookingId,
    required this.sitterId,
    required this.sitterName,
    required this.sitterAvatarUrl,
    required this.isSitterVerified,
    required this.rating,
    required this.distanceMiles,
    required this.responseRatePercent,
    required this.reliabilityRatePercent,
    required this.experienceYears,
    required this.skillTags,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.familyName,
    required this.numberOfChildren,
    required this.dateStart,
    required this.dateEnd,
    required this.timeStart,
    required this.timeEnd,
    required this.hourlyRate,
    required this.numberOfDays,
    required this.additionalNotes,
    required this.addressLines,
    required this.status,
  });
}
