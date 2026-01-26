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
final sitterCurrentBookingsProvider =
    FutureProvider.autoDispose<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  List<BookingModel> active = [];
  try {
    active = await repository.getBookings(tab: 'active');
  } catch (_) {
    active = [];
  }
  if (active.isEmpty) {
    try {
      active = await repository.getBookings(tab: 'in_progress');
    } catch (_) {
      active = [];
    }
  }
  if (active.isEmpty) {
    try {
      active = await repository.getBookings(tab: 'in-progress');
    } catch (_) {
      active = [];
    }
  }
  final upcoming = await repository.getBookings(tab: 'upcoming');

  final merged = <BookingModel>[];
  final seen = <String>{};
  for (final booking in active) {
    final normalized = booking.copyWith(status: 'active');
    merged.add(normalized);
    seen.add(booking.applicationId);
  }
  for (final booking in upcoming) {
    if (seen.contains(booking.applicationId)) {
      continue;
    }
    final normalized = booking.copyWith(status: 'upcoming');
    merged.add(normalized);
  }
  return merged;
});

/// Provider for fetching an active booking session.
final bookingSessionProvider =
    FutureProvider.family<BookingSessionModel, String>((ref, applicationId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookingSession(applicationId);
});
