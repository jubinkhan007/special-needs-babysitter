import 'package:intl/intl.dart';
import '../../domain/booking_details.dart';

class ActiveBookingDetailsUiModel {
  final String sitterId;
  final String sitterName;
  final String avatarUrl;
  final bool isVerified;
  final String rating;
  final String distance;

  // Stats
  final String responseRate;
  final String reliabilityRate;
  final String experience;

  final List<String> skillTags;

  // Service Details Display
  final String familyName;
  final String childrenCount;
  final String dateRange;
  final String timeRange;
  final String hourlyRate;
  final String days;
  final String notes;
  final String address; // Newline separated

  const ActiveBookingDetailsUiModel({
    required this.sitterId,
    required this.sitterName,
    required this.avatarUrl,
    required this.isVerified,
    required this.rating,
    required this.distance,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experience,
    required this.skillTags,
    required this.familyName,
    required this.childrenCount,
    required this.dateRange,
    required this.timeRange,
    required this.hourlyRate,
    required this.days,
    required this.notes,
    required this.address,
  });

  static const empty = ActiveBookingDetailsUiModel(
    sitterId: '',
    sitterName: '',
    avatarUrl: '',
    isVerified: false,
    rating: '',
    distance: '',
    responseRate: '',
    reliabilityRate: '',
    experience: '',
    skillTags: [],
    familyName: '',
    childrenCount: '',
    dateRange: '',
    timeRange: '',
    hourlyRate: '',
    days: '',
    notes: '',
    address: '',
  );

  factory ActiveBookingDetailsUiModel.fromDomain(BookingDetails details) {
    String formatCurrency(double amount) {
      if (amount % 1 == 0) {
        return '\$ ${amount.toInt()}';
      }
      return '\$ ${amount.toStringAsFixed(2)}';
    }

    String formatDateRange(DateTime start, DateTime end) {
      final sameYear = start.year == end.year;
      final startFormat =
          DateFormat(sameYear ? 'd MMM' : 'd MMM yyyy').format(start);
      final endFormat =
          DateFormat(sameYear ? 'd MMM' : 'd MMM yyyy').format(end);
      return '$startFormat - $endFormat';
    }

    String formatTime(DateTime time) {
      final format = time.minute == 0 ? 'hh a' : 'hh:mm a';
      return DateFormat(format).format(time);
    }

    return ActiveBookingDetailsUiModel(
      sitterId: details.sitterId,
      sitterName: details.sitterName,
      avatarUrl: details.avatarUrl,
      isVerified: details.isVerified,
      rating: details.rating.toString(),
      distance: details.distanceText,
      responseRate: '${details.responseRate}%',
      reliabilityRate: '${details.reliabilityRate}%',
      experience: details.experienceText,
      skillTags: details.skills,
      familyName: details.familyName,
      childrenCount: details.numberOfChildren.toString(),
      dateRange: formatDateRange(details.startDate, details.endDate),
      timeRange: '${formatTime(details.startTime)} - ${formatTime(details.endTime)}',
      hourlyRate: '${formatCurrency(details.hourlyRate)}/hr',
      days: details.numberOfDays.toString(),
      notes: details.additionalNotes ?? '',
      address: details.address,
    );
  }
}
