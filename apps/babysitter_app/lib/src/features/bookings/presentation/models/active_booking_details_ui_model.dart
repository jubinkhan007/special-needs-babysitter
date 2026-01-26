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

  // Factory/Mapper from domain would go here or in a provider
}
