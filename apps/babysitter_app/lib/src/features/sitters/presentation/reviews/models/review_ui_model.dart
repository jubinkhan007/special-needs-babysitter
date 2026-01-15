import '../../../domain/review/review.dart';

/// UI model for review display formatting.
class ReviewUiModel {
  final Review review;

  const ReviewUiModel(this.review);

  String get id => review.id;
  String get reviewerName => review.reviewerName;
  String get reviewerAvatarUrl => review.reviewerAvatarUrl;
  double get rating => review.rating;
  String get comment => review.comment;

  /// Formatted time ago string (e.g., "Review 2 Days Ago" -> "2 Days Ago").
  /// Ideally this would use a proper relative time library, but we'll mock formatting for now
  /// or do a simple difference check.
  String get timeAgoText {
    final now = DateTime.now();
    final difference = now.difference(review.createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} Days Ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Hours Ago';
    } else {
      return 'Just Now';
    }
  }
}
