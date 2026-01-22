import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../domain/repositories/bookings_repository.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../data/sources/bookings_remote_datasource.dart';
import '../../data/models/booking_model.dart';

/// Provider for the bookings remote data source.
final bookingsRemoteDataSourceProvider =
    Provider<BookingsRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return BookingsRemoteDataSource(dio);
});

/// Provider for the bookings repository.
final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  final remoteSource = ref.watch(bookingsRemoteDataSourceProvider);
  return BookingsRepositoryImpl(remoteSource);
});

/// Provider for fetching sitter bookings.
/// Pass tab filter (e.g., 'upcoming', 'completed') or null for all bookings.
final sitterBookingsProvider =
    FutureProvider.family<List<BookingModel>, String?>((ref, tab) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookings(tab: tab);
});
