import 'package:auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sources/review_remote_datasource.dart';
import '../../data/sources/review_image_upload_remote_datasource.dart';

final reviewRemoteDataSourceProvider =
    Provider<ReviewRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return ReviewRemoteDataSource(dio);
});

final reviewImageUploadRemoteDataSourceProvider =
    Provider<ReviewImageUploadRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return ReviewImageUploadRemoteDataSource(dio);
});
