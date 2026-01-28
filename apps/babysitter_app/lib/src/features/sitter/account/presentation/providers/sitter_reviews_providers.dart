import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../data/models/sitter_review.dart';
import '../../data/sources/sitter_reviews_remote_datasource.dart';

final sitterReviewsRemoteDataSourceProvider =
    Provider<SitterReviewsRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return SitterReviewsRemoteDataSource(dio);
});

final sitterReviewsProvider =
    FutureProvider.autoDispose<List<SitterReview>>((ref) async {
  final remote = ref.watch(sitterReviewsRemoteDataSourceProvider);
  return remote.getMyReviews();
});
