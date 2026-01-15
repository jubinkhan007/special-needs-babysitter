import '../../../../jobs/domain/applications/booking_application.dart';
import 'package:intl/intl.dart';

class BookingApplicationUiModel {
  final String id;

  // Sitter
  final String sitterName;
  final String avatarUrl;
  final String distanceText;
  final bool isVerified;
  final String ratingText;
  final String responseRateText;
  final String reliabilityRateText;
  final String experienceText;
  final List<String> skills;

  // Content
  final String coverLetter;

  // Service
  final String familyName;
  final String numberOfChildrenText;
  final String dateRangeText;
  final String timeRangeText;
  final String hourlyRateText;
  final String numberOfDaysText;
  final String additionalNotes;
  final String address;

  // Transport
  final List<String> transportationModes;
  final List<String> equipmentAndSafety;
  final List<String> pickupDropoffDetails;

  const BookingApplicationUiModel({
    required this.id,
    required this.sitterName,
    required this.avatarUrl,
    required this.distanceText,
    required this.isVerified,
    required this.ratingText,
    required this.responseRateText,
    required this.reliabilityRateText,
    required this.experienceText,
    required this.skills,
    required this.coverLetter,
    required this.familyName,
    required this.numberOfChildrenText,
    required this.dateRangeText,
    required this.timeRangeText,
    required this.hourlyRateText,
    required this.numberOfDaysText,
    required this.additionalNotes,
    required this.address,
    required this.transportationModes,
    required this.equipmentAndSafety,
    required this.pickupDropoffDetails,
  });

  factory BookingApplicationUiModel.fromDomain(BookingApplication item) {
    final dateFormat = DateFormat('d MMM');
    final timeFormat = DateFormat('hh a');

    String _formatTime(DateTime dt) {
      return timeFormat.format(dt);
    }

    return BookingApplicationUiModel(
      id: item.id,
      sitterName: item.sitterName,
      avatarUrl: item.avatarUrl,
      distanceText: '${item.distanceMiles.toInt()} Miles Away',
      isVerified: item.isVerified,
      ratingText: item.rating.toString(),
      responseRateText: '${item.responseRatePercent}%',
      reliabilityRateText: '${item.reliabilityRatePercent}%',
      experienceText: '${item.experienceYears} Years',
      skills: item.skills,
      coverLetter: item.coverLetter,
      familyName: item.familyName,
      numberOfChildrenText: item.numberOfChildren.toString(),
      dateRangeText:
          '${dateFormat.format(item.startDate)} - ${dateFormat.format(item.endDate)}',
      timeRangeText:
          '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}',
      hourlyRateText: '\$ ${item.hourlyRate.toInt()}/hr',
      numberOfDaysText: item.numberOfDays.toString(),
      additionalNotes: item.additionalNotes,
      address: item.address,
      transportationModes: item.transportationModes,
      equipmentAndSafety: item.equipmentAndSafety,
      pickupDropoffDetails: item.pickupDropoffDetails,
    );
  }
}
