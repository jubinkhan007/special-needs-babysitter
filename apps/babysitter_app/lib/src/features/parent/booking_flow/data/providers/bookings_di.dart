import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart'; // For authDioProvider

/// Provider for BookingsRepository
final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = BookingsRemoteDataSource(dio);
  return BookingsRepositoryImpl(dataSource);
});
