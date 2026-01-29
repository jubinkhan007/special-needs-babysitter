import 'booking_status.dart';

class BookingDetails {
  final String id;
  final String jobId; // The actual job ID (different from application/booking id)
  final String sitterId;
  final String sitterName;
  final String avatarUrl;
  final bool isVerified;
  final double rating;
  final int responseRate;
  final int reliabilityRate;
  final String experienceText;
  final String distanceText;

  // Status
  final BookingStatus status;

  // Service Details
  final String familyName;
  final int numberOfChildren;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime; // Only time part matters
  final DateTime endTime; // Only time part matters
  final double hourlyRate;
  final int numberOfDays;
  final String? additionalNotes;
  final String address;
  final List<String> skills; // CPR, First-aid etc.

  // Payment Details (nullable as only for completed)
  final double? subTotal;
  final int? totalHours;
  final double? platformFee;
  final double? discount;

  // Actual Work Details (for completed bookings)
  final int? actualMinutesWorked;
  final double? actualHoursWorked;
  final double? actualPayout;
  final double? totalCharged;
  final double? refundAmount;
  final String? paymentStatus;
  final DateTime? clockInTimeActual;
  final DateTime? clockOutTimeActual;

  const BookingDetails({
    required this.id,
    required this.jobId,
    required this.sitterId,
    required this.sitterName,
    required this.avatarUrl,
    required this.isVerified,
    required this.rating,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceText,
    required this.distanceText,
    required this.status,
    required this.familyName,
    required this.numberOfChildren,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.hourlyRate,
    required this.numberOfDays,
    this.additionalNotes,
    required this.address,
    this.skills = const [],
    this.subTotal,
    this.totalHours,
    this.platformFee,
    this.discount,
    this.actualMinutesWorked,
    this.actualHoursWorked,
    this.actualPayout,
    this.totalCharged,
    this.refundAmount,
    this.paymentStatus,
    this.clockInTimeActual,
    this.clockOutTimeActual,
  });

  double get estimatedTotalCost {
    // Basic calculation logic, real app might get this from backend
    if (subTotal != null && platformFee != null) {
      return subTotal! + platformFee! - (discount ?? 0);
    }
    return (hourlyRate * (totalHours ?? 0)) + (platformFee ?? 0);
  }
}

class BookingDetailsArgs {
  final String bookingId;
  final BookingStatus? status; // Optional hint

  const BookingDetailsArgs({required this.bookingId, this.status});
}
