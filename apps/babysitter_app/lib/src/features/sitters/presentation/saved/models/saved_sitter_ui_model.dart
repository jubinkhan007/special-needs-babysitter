import '../../../domain/saved/saved_sitter.dart';

/// UI model for formatting SavedSitter data for display.
class SavedSitterUiModel {
  final SavedSitter sitter;

  const SavedSitterUiModel(this.sitter);

  String get id => sitter.id;
  String get name => sitter.name;
  bool get isVerified => sitter.isVerified;
  String get ratingText => sitter.rating.toStringAsFixed(1);
  String get location => sitter.location;
  String get avatarUrl => sitter.avatarUrl;
  bool get isBookmarked => sitter.isBookmarked;
  List<String> get skills => sitter.skills;

  // Stats
  String get responseRateText => '${sitter.responseRate}%';
  String get reliabilityRateText => '${sitter.reliabilityRate}%';
  String get experienceText => '${sitter.experienceYears} Years';

  // Price - split for styling
  String get priceDollarAmount => '\$${sitter.hourlyRate.toInt()}';
  String get priceSuffix => '/hr';
}
