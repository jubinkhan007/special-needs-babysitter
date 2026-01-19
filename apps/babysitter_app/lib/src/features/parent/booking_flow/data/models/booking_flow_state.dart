import 'package:flutter/material.dart';

/// State model for booking flow data collected across steps 1-3
class BookingFlowState {
  // Step 1 Data
  final List<String> selectedChildIds;
  final List<String> selectedChildNames;
  final double payRate;
  final String? additionalDetails;

  // Step 2 Data
  final String? jobTitle;
  final String? dateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;

  // Step 3 Data
  final String? streetAddress;
  final String? aptUnit;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;

  // Sitter Data (passed from profile)
  final String? sitterId;
  final String? sitterName;
  final String? sitterAvatarUrl;
  final double? sitterRating;
  final String? sitterDistance;
  final String? sitterResponseRate;
  final String? sitterReliabilityRate;
  final String? sitterExperience;
  final List<String> sitterBadges;

  // Transportation Preferences (from child details)
  final String? transportationMode;
  final String? equipmentSafety;
  final String? pickupDropoffDetails;

  // Payment Method
  final String selectedPaymentMethod;

  const BookingFlowState({
    this.selectedChildIds = const [],
    this.selectedChildNames = const [],
    this.payRate = 0,
    this.additionalDetails,
    this.jobTitle,
    this.dateRange,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.streetAddress,
    this.aptUnit,
    this.city,
    this.state,
    this.zipCode,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.sitterId,
    this.sitterName,
    this.sitterAvatarUrl,
    this.sitterRating,
    this.sitterDistance,
    this.sitterResponseRate,
    this.sitterReliabilityRate,
    this.sitterExperience,
    this.sitterBadges = const [],
    this.transportationMode,
    this.equipmentSafety,
    this.pickupDropoffDetails,
    this.selectedPaymentMethod = 'Paypal',
  });

  BookingFlowState copyWith({
    List<String>? selectedChildIds,
    List<String>? selectedChildNames,
    double? payRate,
    String? additionalDetails,
    String? jobTitle,
    String? dateRange,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? streetAddress,
    String? aptUnit,
    String? city,
    String? state,
    String? zipCode,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? sitterId,
    String? sitterName,
    String? sitterAvatarUrl,
    double? sitterRating,
    String? sitterDistance,
    String? sitterResponseRate,
    String? sitterReliabilityRate,
    String? sitterExperience,
    List<String>? sitterBadges,
    String? transportationMode,
    String? equipmentSafety,
    String? pickupDropoffDetails,
    String? selectedPaymentMethod,
  }) {
    return BookingFlowState(
      selectedChildIds: selectedChildIds ?? this.selectedChildIds,
      selectedChildNames: selectedChildNames ?? this.selectedChildNames,
      payRate: payRate ?? this.payRate,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      jobTitle: jobTitle ?? this.jobTitle,
      dateRange: dateRange ?? this.dateRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      streetAddress: streetAddress ?? this.streetAddress,
      aptUnit: aptUnit ?? this.aptUnit,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      sitterId: sitterId ?? this.sitterId,
      sitterName: sitterName ?? this.sitterName,
      sitterAvatarUrl: sitterAvatarUrl ?? this.sitterAvatarUrl,
      sitterRating: sitterRating ?? this.sitterRating,
      sitterDistance: sitterDistance ?? this.sitterDistance,
      sitterResponseRate: sitterResponseRate ?? this.sitterResponseRate,
      sitterReliabilityRate:
          sitterReliabilityRate ?? this.sitterReliabilityRate,
      sitterExperience: sitterExperience ?? this.sitterExperience,
      sitterBadges: sitterBadges ?? this.sitterBadges,
      transportationMode: transportationMode ?? this.transportationMode,
      equipmentSafety: equipmentSafety ?? this.equipmentSafety,
      pickupDropoffDetails: pickupDropoffDetails ?? this.pickupDropoffDetails,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  /// Computed: Full address string
  String get fullAddress {
    final parts = [streetAddress, aptUnit, city, state, zipCode]
        .where((p) => p != null && p.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  /// Computed: Number of days between start and end date
  int get numberOfDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }

  /// Computed: Hours per day based on start and end time
  double get hoursPerDay {
    if (startTime == null || endTime == null) return 0;

    try {
      final start = _parseTime(startTime!);
      final end = _parseTime(endTime!);

      double startDouble = start.hour + start.minute / 60.0;
      double endDouble = end.hour + end.minute / 60.0;

      // Handle overnight shifts if end time is before start time
      if (endDouble < startDouble) {
        endDouble += 24;
      }

      return endDouble - startDouble;
    } catch (e) {
      return 0;
    }
  }

  /// Computed: Total hours for the entire booking
  double get totalHours => hoursPerDay * numberOfDays;

  /// Computed: Subtotal (Total Hours * Hourly Rate)
  double get subTotal => totalHours * payRate;

  /// Computed: Platform Fee (Fixed 5% for now or $20 logic)
  /// Using a simple 5% logic for dynamic calculation
  /// Or keeping it close to the mockup example ($20 for $300 is ~6.6%)
  /// constant flat fee + percentage is common. Let's use 5% + $5 flat fee for realism
  /// actually adhering to the mockup: $300 subtotal -> $20 fee. Let's strictly use 6.67% ~ $20
  /// Let's stick to a standard 5% for simplicity.
  double get platformFee => subTotal * 0.20;

  /// Computed: Total Cost
  double get totalCost => subTotal + platformFee;

  // Helper to parse "10:00 AM" format
  TimeOfDay _parseTime(String timeStr) {
    final cleanTime = timeStr.trim();
    // Expected format: "10:00 AM"
    final looseParts = cleanTime.split(' ');
    if (looseParts.length != 2) throw FormatException('Invalid time format');

    final timeParts = looseParts[0].split(':');
    final period = looseParts[1].toUpperCase();

    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Convert state to API request payload for POST /direct-bookings
  Map<String, dynamic> toDirectBookingPayload() {
    return {
      'sitterUserId': sitterId,
      'childIds': selectedChildIds,
      'title': jobTitle ?? 'Sitter Needed',
      'startDate': startDate != null
          ? '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}'
          : null,
      'endDate': endDate != null
          ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
          : null,
      'startTime': _convertTo24HourFormat(startTime),
      'endTime': _convertTo24HourFormat(endTime),
      'address': {
        'streetAddress': streetAddress ?? '',
        'aptUnit': aptUnit ?? '',
        'city': city ?? '',
        'state': state ??
            'CA', // Default to CA if somehow null to avoid validation error
        'zipCode': zipCode ?? '',
        'latitude': 0.0, // Not collected in current flow
        'longitude': 0.0, // Not collected in current flow
      },
      'additionalDetails': additionalDetails ?? '',
      'payRate': payRate.toInt(),
      'emergencyContact': {
        'name': emergencyContactName ?? '',
        'phone': emergencyContactPhone ?? '',
        'relationship': emergencyContactRelation ?? '',
      },
    }..removeWhere((key, value) => value == null);
  }

  /// Convert "10:00 AM" format to "10:00" (24-hour format for API)
  String? _convertTo24HourFormat(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final time = _parseTime(timeStr);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeStr; // Return as-is if parsing fails
    }
  }
}
