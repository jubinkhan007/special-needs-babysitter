import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../domain/repositories/bookings_repository.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../data/sources/bookings_remote_datasource.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/booking_session_model.dart';

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

/// Provider for the sitter's current bookings (active + upcoming).
/// Persists for session - use ref.invalidate() after mutations.
final sitterCurrentBookingsProvider =
    FutureProvider<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);

  // Fetch active and upcoming bookings in parallel
  // Note: API only supports 'active' and 'upcoming' tabs
  final results = await Future.wait([
    repository.getBookings(tab: 'active').catchError((_) => <BookingModel>[]),
    repository.getBookings(tab: 'upcoming').catchError((_) => <BookingModel>[]),
  ]);

  final active = results[0];
  final upcoming = results[1];

  print(
      'DEBUG: Fetched ${active.length} active bookings, ${upcoming.length} upcoming bookings');

  final merged = <BookingModel>[];
  final seen = <String>{};

  for (final booking in active) {
    print(
        'DEBUG: Active booking - id: ${booking.id}, applicationId: ${booking.applicationId}, title: ${booking.title}');
    final normalizedStatus =
        (booking.status != null && booking.status!.trim().isNotEmpty)
            ? booking.status
            : 'active';
    final normalized = booking.copyWith(status: normalizedStatus);
    merged.add(normalized);
    seen.add(booking.applicationId);
  }

  for (final booking in upcoming) {
    if (seen.contains(booking.applicationId)) {
      continue;
    }
    print(
        'DEBUG: Upcoming booking - id: ${booking.id}, applicationId: ${booking.applicationId}, title: ${booking.title}');
    final normalized = booking.copyWith(status: 'upcoming');
    merged.add(normalized);
  }

  print('DEBUG: Total merged bookings: ${merged.length}');
  return merged;
});

/// Provider for fetching an active booking session.
final bookingSessionProvider =
    FutureProvider.family<BookingSessionModel, String>((ref, applicationId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookingSession(applicationId);
});
