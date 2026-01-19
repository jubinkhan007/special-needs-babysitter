class SitterListItemModel {
  final String id;
  final String userId;
  final String name;
  final String imageAssetPath;
  final bool isVerified;
  final double rating;
  final String distanceText; // e.g. "2 Miles Away"
  final int responseRate;
  final int reliabilityRate;
  final int experienceYears;
  final List<String> tags;
  final double hourlyRate;

  const SitterListItemModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageAssetPath,
    required this.isVerified,
    required this.rating,
    required this.distanceText,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceYears,
    required this.tags,
    required this.hourlyRate,
  });
}
