import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/sources/booking_session_local_datasource.dart';
import 'bookings_providers.dart';
import '../controllers/session_tracking_controller.dart';

final bookingSessionLocalDataSourceProvider =
    Provider<BookingSessionLocalDataSource>((ref) {
  return BookingSessionLocalDataSource();
});

final sessionTrackingControllerProvider =
    StateNotifierProvider<SessionTrackingController, SessionTrackingState>(
        (ref) {
  final repository = ref.watch(bookingsRepositoryProvider);
  final localDataSource = ref.watch(bookingSessionLocalDataSourceProvider);
  return SessionTrackingController(repository, localDataSource);
});

final sessionTickerProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});
