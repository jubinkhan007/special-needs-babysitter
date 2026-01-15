class ApplicationItem {
  final String id;
  final String sitterName;
  final String avatarUrl; // In real app, network URL
  final bool isVerified;
  final double distanceMiles;
  final double rating;
  final int responseRatePercent;
  final int reliabilityRatePercent;
  final int experienceYears;
  final String jobTitle;
  final DateTime scheduledDate;
  final bool isApplication; // To show "Application" chip (assuming logic)
  final String? status; // From API: pending, accepted, rejected, etc.
  final String? sitterId; // Sitter's ID for navigation

  const ApplicationItem({
    required this.id,
    required this.sitterName,
    required this.avatarUrl,
    required this.isVerified,
    required this.distanceMiles,
    required this.rating,
    required this.responseRatePercent,
    required this.reliabilityRatePercent,
    required this.experienceYears,
    required this.jobTitle,
    required this.scheduledDate,
    required this.isApplication,
    this.status,
    this.sitterId,
    this.coverLetter,
    this.skills,
  });

  final String? coverLetter;
  final List<String>? skills;
}
