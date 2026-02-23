import 'booking_status.dart';

class Booking {
  final String id;
  final String sitterId;
  final String sitterName;
  final String distanceText; // "5 Miles Away"
  final double rating; // 4.5
  final int responseRate; // 95
  final int reliabilityRate; // 95
  final String experienceText; // "5 Years"
  final DateTime scheduledDate; // "20 May,2025"
  final BookingStatus status;
  final String avatarAssetOrUrl;
  final bool isVerified;

  const Booking({
    required this.id,
    required this.sitterId,
    required this.sitterName,
    required this.distanceText,
    required this.rating,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceText,
    required this.scheduledDate,
    required this.status,
    required this.avatarAssetOrUrl,
    this.isVerified = false,
  });
}
