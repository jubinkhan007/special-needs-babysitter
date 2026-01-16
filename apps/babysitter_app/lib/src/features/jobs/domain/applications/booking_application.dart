class BookingApplication {
  final String id;
  // Sitter Details
  final String sitterName;
  final String avatarUrl;
  final bool isVerified;
  final double distanceMiles;
  final double rating;
  final int responseRatePercent;
  final int reliabilityRatePercent;
  final int experienceYears;
  final List<String> skills; // e.g., CPR, First-aid

  // Application Details
  final String coverLetter;
  final String? status;

  // Job/Service Details
  final String familyName;
  final int numberOfChildren;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final double hourlyRate;
  final int numberOfDays;
  final String additionalNotes;
  final String address;

  // Transportation Preferences
  final List<String> transportationModes;
  final List<String> equipmentAndSafety;
  final List<String> pickupDropoffDetails;

  const BookingApplication({
    required this.id,
    required this.sitterName,
    required this.avatarUrl,
    required this.isVerified,
    required this.distanceMiles,
    required this.rating,
    required this.responseRatePercent,
    required this.reliabilityRatePercent,
    required this.experienceYears,
    required this.skills,
    required this.coverLetter,
    this.status,
    required this.familyName,
    required this.numberOfChildren,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.hourlyRate,
    required this.numberOfDays,
    required this.additionalNotes,
    required this.address,
    required this.transportationModes,
    required this.equipmentAndSafety,
    required this.pickupDropoffDetails,
  });
}
