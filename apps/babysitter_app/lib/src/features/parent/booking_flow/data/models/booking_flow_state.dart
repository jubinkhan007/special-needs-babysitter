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
  final double? latitude;
  final double? longitude;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String? emergencyContactEmail;
  final String? emergencyContactAddress;
  final String? emergencyContactInstructions;

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
  final String? pickupLocation;
  final String? dropoffLocation;
  final String? transportSpecialInstructions;

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
    this.latitude,
    this.longitude,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.emergencyContactEmail,
    this.emergencyContactAddress,
    this.emergencyContactInstructions,
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
    this.pickupLocation,
    this.dropoffLocation,
    this.transportSpecialInstructions,
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
    double? latitude,
    double? longitude,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? emergencyContactEmail,
    String? emergencyContactAddress,
    String? emergencyContactInstructions,
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
    String? pickupLocation,
    String? dropoffLocation,
    String? transportSpecialInstructions,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      emergencyContactEmail:
          emergencyContactEmail ?? this.emergencyContactEmail,
      emergencyContactAddress:
          emergencyContactAddress ?? this.emergencyContactAddress,
      emergencyContactInstructions:
          emergencyContactInstructions ?? this.emergencyContactInstructions,
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
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      transportSpecialInstructions:
          transportSpecialInstructions ?? this.transportSpecialInstructions,
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

      // Handle overnight/24-hour shifts:
      // - If end time equals start time, it's a 24-hour shift
      // - If end time is before start time, it crosses midnight
      if (endDouble <= startDouble) {
        endDouble += 24;
      }

      return endDouble - startDouble;
    } catch (e) {
      return 0;
    }
  }

  /// Computed: Total hours for the entire booking
  /// This calculates the actual duration from start datetime to end datetime
  double get totalHours {
    if (startDate == null || endDate == null || startTime == null || endTime == null) {
      return 0;
    }

    try {
      // Parse the times
      final startTimeOfDay = _parseTime(startTime!);
      final endTimeOfDay = _parseTime(endTime!);

      // Create full datetime objects
      final startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTimeOfDay.hour,
        startTimeOfDay.minute,
      );

      final endDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTimeOfDay.hour,
        endTimeOfDay.minute,
      );

      // Calculate the actual duration
      final duration = endDateTime.difference(startDateTime);
      return duration.inMinutes / 60.0;
    } catch (e) {
      // Fallback to old calculation if parsing fails
      return hoursPerDay * numberOfDays;
    }
  }

  /// Computed: Subtotal (Total Hours * Hourly Rate)
  double get subTotal => totalHours * payRate;

  /// Computed: Platform Fee (15% of subtotal)
  /// This is a service fee charged to parents for using the platform
  double get platformFee => subTotal * 0.15;

  /// Computed: Total Cost
  /// The total amount to be charged, including platform fee
  double get totalCost => subTotal + platformFee;
  
  /// Validates that the booking meets minimum amount requirements
  /// Returns an error message if invalid, null if valid
  String? validateAmount() {
    if (totalHours <= 0) {
      return 'Invalid booking duration. Please check your start and end times.';
    }
    if (payRate <= 0) {
      return 'Hourly rate must be greater than 0.';
    }
    // Minimum booking amount is $5.00 (Stripe requirement)
    if (totalCost < 5.0) {
      return 'Minimum booking amount is \$5.00. Please increase hours or rate.';
    }
    return null;
  }

  // Helper to parse "10:00 AM" format
  TimeOfDay _parseTime(String timeStr) {
    final cleanTime = timeStr.trim();
    // Expected format: "10:00 AM"
    final looseParts = cleanTime.split(' ');
    if (looseParts.length != 2) throw const FormatException('Invalid time format');

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
    final title = jobTitle ?? 'Sitter Needed';
    return {
      'sitterId': sitterId,
      // Backwards-compatible key for APIs expecting userId naming
      'sitterUserId': sitterId,
      'childIds': selectedChildIds,
      'title': title,
      // Some endpoints expect jobTitle instead of title
      'jobTitle': title,
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
        'latitude': latitude ?? 0.0,
        'longitude': longitude ?? 0.0,
      },
      // Location as string (e.g., "San Francisco, CA") for backend compatibility
      'location': '${city ?? ''}, ${state ?? 'CA'}',
      // Full address string for backend
      'fullAddress': fullAddress,
      'additionalDetails': additionalDetails ?? '',
      'payRate': payRate.toInt(),
      'emergencyContact': {
        'name': emergencyContactName ?? '',
        'phone': emergencyContactPhone ?? '',
        'relationship': emergencyContactRelation ?? '',
        'email': emergencyContactEmail ?? '',
        'address': emergencyContactAddress ?? '',
        'specialInstructions': emergencyContactInstructions ?? '',
      },
      'pickupLocation': pickupLocation ?? '',
      'dropoffLocation': dropoffLocation ?? '',
      'transportSpecialInstructions': transportSpecialInstructions ?? '',
      // Transportation arrays - split from comma-separated strings
      'transportationModes': transportationMode?.split(', ').where((s) => s.isNotEmpty).toList() ?? <String>[],
      'equipmentSafety': equipmentSafety?.split(', ').where((s) => s.isNotEmpty).toList() ?? <String>[],
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
