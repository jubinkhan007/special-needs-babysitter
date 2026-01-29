class SitterReview {
  final String id;
  final String jobId;
  final String reviewerId;
  final String revieweeId;
  final String reviewerRole;
  final String reviewerName;
  final String reviewerAvatar;
  final double rating;
  final String reviewText;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SitterReview({
    required this.id,
    required this.jobId,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerRole,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.rating,
    required this.reviewText,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SitterReview.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] as Map<String, dynamic>?;
    final reviewerName = _buildName(reviewer);
    final reviewerAvatar = (reviewer?['profilePhotoUrl'] ?? json['imageUrl'] ?? '')
        .toString();
    return SitterReview(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      jobId: (json['jobId'] ?? '').toString(),
      reviewerId: (reviewer?['id'] ?? json['reviewerId'] ?? '').toString(),
      revieweeId: (json['revieweeId'] ?? '').toString(),
      reviewerRole: (json['reviewerRole'] ?? '').toString(),
      reviewerName: reviewerName,
      reviewerAvatar: reviewerAvatar,
      rating: _toDouble(json['rating']),
      reviewText: (json['reviewText'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is num) {
      final milliseconds = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
    }
    return null;
  }

  static String _buildName(Map<String, dynamic>? payload) {
    if (payload == null) return '';
    final first = (payload['firstName'] ?? '').toString().trim();
    final last = (payload['lastName'] ?? '').toString().trim();
    if (first.isEmpty && last.isEmpty) {
      return '';
    }
    return [first, last].where((part) => part.isNotEmpty).join(' ');
  }
}
