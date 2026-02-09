class SitterListItemModel {
  final String id;
  final String userId;
  final String name;
  final String imageAssetPath;
  final bool isVerified;
  final double rating;
  final int reviewCount;
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
    this.reviewCount = 0,
    required this.distanceText,
    required this.responseRate,
    required this.reliabilityRate,
    required this.experienceYears,
    required this.tags,
    required this.hourlyRate,
  });

  SitterListItemModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? imageAssetPath,
    bool? isVerified,
    double? rating,
    int? reviewCount,
    String? distanceText,
    int? responseRate,
    int? reliabilityRate,
    int? experienceYears,
    List<String>? tags,
    double? hourlyRate,
  }) {
    return SitterListItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distanceText: distanceText ?? this.distanceText,
      responseRate: responseRate ?? this.responseRate,
      reliabilityRate: reliabilityRate ?? this.reliabilityRate,
      experienceYears: experienceYears ?? this.experienceYears,
      tags: tags ?? this.tags,
      hourlyRate: hourlyRate ?? this.hourlyRate,
    );
  }
}
