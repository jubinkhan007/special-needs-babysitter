/// Domain model for a saved sitter.
class SavedSitter {
  final String id;
  final String name;
  final bool isVerified;
  final double rating;
  final String location;
  final int responseRate;
  final int reliabilityRate;
  final int experienceYears;
  final double hourlyRate;
  final List<String> skills;
  final String avatarUrl;
  final bool isBookmarked;

  const SavedSitter({
    required this.id,
    required this.name,
    this.isVerified = false,
    this.rating = 0.0,
    required this.location,
    this.responseRate = 0,
    this.reliabilityRate = 0,
    this.experienceYears = 0,
    this.hourlyRate = 0.0,
    this.skills = const [],
    this.avatarUrl = '',
    this.isBookmarked = true,
  });
}
