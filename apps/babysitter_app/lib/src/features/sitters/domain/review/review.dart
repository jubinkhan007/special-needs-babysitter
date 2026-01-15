/// Domain model for a single review.
class Review {
  final String id;
  final String reviewerName;
  final String reviewerAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.reviewerName,
    this.reviewerAvatarUrl = '',
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
