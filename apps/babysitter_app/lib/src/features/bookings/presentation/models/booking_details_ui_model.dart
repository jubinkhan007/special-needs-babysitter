import 'package:intl/intl.dart';
import '../../domain/booking_details.dart';

class BookingDetailsUiModel {
  final String sitterName;
  final String avatarUrl;
  final bool isVerified;
  final String rating;
  final String responseRate;
  final String reliabilityRate;
  final String experience;
  final String distance;
  final List<String> skills;

  // Service Details Display Strings
  final String familyName;
  final String numberOfChildren;
  final String dateRange;
  final String timeRange;
  final String hourlyRate; // "$ 20/hr"
  final String numberOfDays;
  final String additionalNotes;
  final String address;

  // Payment Details Display Strings
  final String subTotal;
  final String totalHours;
  final String platformFee;
  final String discount;
  final String estimatedTotalCost;

  // Actual Work Details (for completed bookings)
  final String? actualMinutesWorked;
  final String? actualHoursWorked;
  final String? actualPayout;
  final String? totalCharged;
  final String? refundAmount;
  final String? paymentStatus;
  final String? clockInTimeActual;
  final String? clockOutTimeActual;

  BookingDetailsUiModel({
    required this.sitterName,
    required this.avatarUrl,
    required this.isVerified,
    required this.rating,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experience,
    required this.distance,
    required this.skills,
    required this.familyName,
    required this.numberOfChildren,
    required this.dateRange,
    required this.timeRange,
    required this.hourlyRate,
    required this.numberOfDays,
    required this.additionalNotes,
    required this.address,
    required this.subTotal,
    required this.totalHours,
    required this.platformFee,
    required this.discount,
    required this.estimatedTotalCost,
    this.actualMinutesWorked,
    this.actualHoursWorked,
    this.actualPayout,
    this.totalCharged,
    this.refundAmount,
    this.paymentStatus,
    this.clockInTimeActual,
    this.clockOutTimeActual,
  });

  factory BookingDetailsUiModel.fromDomain(BookingDetails details) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final timeFormat = DateFormat('h:mm a'); // 09 AM
    final dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');

    String formatDateRange(DateTime start, DateTime end) {
      return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
    }

    String formatTimeRange(DateTime start, DateTime end) {
      return '${timeFormat.format(start)} - ${timeFormat.format(end)}';
    }

    String formatCurrency(double amount) {
      // Manage decimals: if partial, show 2 decimals, else 0
      if (amount % 1 == 0) {
        return '\$ ${amount.toInt()}';
      }
      return '\$ ${amount.toStringAsFixed(2)}';
    }

    String? formatOptionalDateTime(DateTime? dateTime) {
      if (dateTime == null) return null;
      return dateTimeFormat.format(dateTime);
    }

    return BookingDetailsUiModel(
      sitterName: details.sitterName,
      avatarUrl: details.avatarUrl,
      isVerified: details.isVerified,
      rating: details.rating.toString(),
      responseRate: '${details.responseRate}%',
      reliabilityRate: '${details.reliabilityRate}%',
      experience: details.experienceText,
      distance: details.distanceText,
      skills: details.skills,
      familyName: details.familyName,
      numberOfChildren: details.numberOfChildren.toString(),
      dateRange: formatDateRange(details.startDate, details.endDate),
      timeRange: formatTimeRange(details.startTime, details.endTime),
      hourlyRate: '${formatCurrency(details.hourlyRate)}/hr',
      numberOfDays: details.numberOfDays.toString(),
      additionalNotes: details.additionalNotes ?? '',
      address: details.address,
      subTotal: formatCurrency(details.subTotal ?? 0),
      totalHours: '${details.totalHours ?? 0} Hours',
      platformFee: formatCurrency(details.platformFee ?? 0),
      discount: formatCurrency(details.discount ?? 0),
      estimatedTotalCost: formatCurrency(details.estimatedTotalCost),
      actualMinutesWorked: details.actualMinutesWorked != null 
          ? '${details.actualMinutesWorked} min' 
          : null,
      actualHoursWorked: details.actualHoursWorked != null 
          ? '${details.actualHoursWorked!.toStringAsFixed(3)} hrs' 
          : null,
      actualPayout: details.actualPayout != null 
          ? formatCurrency(details.actualPayout!) 
          : null,
      totalCharged: details.totalCharged != null 
          ? formatCurrency(details.totalCharged!) 
          : null,
      refundAmount: details.refundAmount != null && details.refundAmount! > 0
          ? formatCurrency(details.refundAmount!) 
          : null,
      paymentStatus: details.paymentStatus,
      clockInTimeActual: formatOptionalDateTime(details.clockInTimeActual),
      clockOutTimeActual: formatOptionalDateTime(details.clockOutTimeActual),
    );
  }
}
