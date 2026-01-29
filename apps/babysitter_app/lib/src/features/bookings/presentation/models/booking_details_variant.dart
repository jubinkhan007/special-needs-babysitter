import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/booking_status.dart';

enum ServiceFieldType {
  familyName,
  numberOfChildren,
  date,
  time,
  hourlyRate,
  numberOfDays,
  additionalNotes,
  address,
}

enum PaymentFieldType {
  subTotal,
  totalHours,
  hourlyRate,
  platformFee,
  discount,
  estimatedTotal,
  // Actual work fields (for completed bookings)
  actualMinutesWorked,
  actualHoursWorked,
  actualPayout,
  totalCharged,
  refundAmount,
  paymentStatus,
  clockInTimeActual,
  clockOutTimeActual,
}

class BookingDetailsVariant {
  final String appBarTitle;
  final BookingStatus status;
  final bool showPaymentBlock;
  final String ctaLabel;
  final List<ServiceFieldType> visibleServiceFields;
  final List<PaymentFieldType> visiblePaymentFields;

  // Chip style getters
  final Color chipBgColor;
  final Color chipDotColor;
  final Color chipTextColor;

  const BookingDetailsVariant({
    required this.appBarTitle,
    required this.status,
    required this.showPaymentBlock,
    required this.ctaLabel,
    required this.visibleServiceFields,
    this.visiblePaymentFields = const [],
    required this.chipBgColor,
    required this.chipDotColor,
    required this.chipTextColor,
  });

  factory BookingDetailsVariant.upcoming() {
    return BookingDetailsVariant(
      appBarTitle: 'Upcoming Booking',
      status: BookingStatus.upcoming,
      showPaymentBlock: false,
      ctaLabel: 'Message',
      visibleServiceFields: ServiceFieldType.values, // All fields
      chipBgColor: AppTokens.chipGreenBg,
      chipDotColor: AppTokens.chipGreenDot,
      chipTextColor: AppTokens
          .textPrimary, // Or specific green text if needed, Figma usually uses dark text
    );
  }

  factory BookingDetailsVariant.pending() {
    return BookingDetailsVariant(
      appBarTitle: 'Pending Booking',
      status: BookingStatus.pending,
      showPaymentBlock: false,
      ctaLabel: 'Message',
      visibleServiceFields: ServiceFieldType.values, // All fields
      chipBgColor: AppTokens.chipOrangeBg,
      chipDotColor: AppTokens.chipOrangeDot,
      chipTextColor: AppTokens.textPrimary,
    );
  }

  factory BookingDetailsVariant.completed() {
    return BookingDetailsVariant(
      appBarTitle: 'Completed Booking',
      status: BookingStatus.completed,
      showPaymentBlock: true,
      ctaLabel: 'Leave a Review',
      // Reduced set according to plan
      visibleServiceFields: [
        ServiceFieldType.numberOfChildren, // "No. Of Child"
        ServiceFieldType.date,
        ServiceFieldType.numberOfDays,
        ServiceFieldType.time,
        ServiceFieldType.address,
      ],
      visiblePaymentFields: [
        PaymentFieldType.hourlyRate,
        PaymentFieldType.actualMinutesWorked,
        PaymentFieldType.actualHoursWorked,
        PaymentFieldType.actualPayout,
        PaymentFieldType.platformFee,
        PaymentFieldType.totalCharged,
        PaymentFieldType.refundAmount,
      ],
      chipBgColor: AppTokens.chipPurpleBg,
      chipDotColor: AppTokens.chipPurpleDot,
      chipTextColor: AppTokens.textPrimary,
    );
  }

  // Method to get variant from status
  static BookingDetailsVariant fromStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
      case BookingStatus.active: // Treat active as upcoming for now or add specific
      case BookingStatus.clockedOut:
        return BookingDetailsVariant.upcoming();
      case BookingStatus.pending:
        return BookingDetailsVariant.pending();
      case BookingStatus.completed:
        return BookingDetailsVariant.completed();
      default:
        // Fallback for cancelled or others to upcoming (or create separate)
        return BookingDetailsVariant.upcoming();
    }
  }
}
