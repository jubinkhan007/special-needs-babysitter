import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/auth/auth.dart';

import 'package:babysitter_app/src/features/sitter/account/data/models/sitter_review.dart';
import 'package:babysitter_app/src/features/sitter/account/data/sources/sitter_reviews_remote_datasource.dart';

final sitterReviewsRemoteDataSourceProvider =
    Provider<SitterReviewsRemoteDataSource>((ref) {
      final dio = ref.watch(authDioProvider);
      return SitterReviewsRemoteDataSource(dio);
    });

final sitterReviewsProvider = FutureProvider.autoDispose<List<SitterReview>>((
  ref,
) async {
  final remote = ref.watch(sitterReviewsRemoteDataSourceProvider);
  return remote.getMyReviews();
});
