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
    );
  }

  /// Computed: Full address string
  String get fullAddress {
    final parts = [streetAddress, aptUnit, city, zipCode]
        .where((p) => p != null && p.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  /// Computed: Number of days between start and end date
  int get numberOfDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }
}
