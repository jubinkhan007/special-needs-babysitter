import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/domain/domain.dart';
import 'package:babysitter_app/src/packages/data/data.dart';
import 'package:babysitter_app/src/packages/auth/auth.dart'; // For authDioProvider

/// Provider for BookingsRepository
final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = BookingsRemoteDataSource(dio);
  return BookingsRepositoryImpl(dataSource);
});
