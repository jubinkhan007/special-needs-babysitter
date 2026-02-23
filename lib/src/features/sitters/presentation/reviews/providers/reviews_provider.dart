import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/sitters/data/datasources/sitters_remote_datasource.dart';
import 'package:babysitter_app/src/features/sitters/data/sitters_data_di.dart';
import 'package:babysitter_app/src/features/sitters/domain/review/review.dart';

/// Provider for fetching reviews for a specific sitter
final sitterReviewsProvider = FutureProvider.family<List<Review>, String>((
  ref,
  sitterUserId,
) async {
  final dataSource = ref.watch(sittersRemoteDataSourceProvider);
  return _fetchReviews(dataSource, sitterUserId);
});

Future<List<Review>> _fetchReviews(
  SittersRemoteDataSource dataSource,
  String sitterUserId,
) async {
  final reviewDtos = await dataSource.fetchReviews(sitterUserId);

  return reviewDtos.map((dto) {
    final reviewer = dto.reviewer;
    return Review(
      id: dto.id,
      reviewerName: reviewer?.displayName ?? 'Anonymous',
      reviewerAvatarUrl: reviewer?.profilePhotoUrl ?? '',
      rating: dto.rating,
      comment: dto.reviewText,
      createdAt: dto.createdAt ?? DateTime.now(),
    );
  }).toList();
}
