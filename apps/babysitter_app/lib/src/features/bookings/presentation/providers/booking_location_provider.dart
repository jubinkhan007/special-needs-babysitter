import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/booking_location.dart';
import '../../data/bookings_data_di.dart';

final bookingLocationProvider =
    FutureProvider.family<BookingLocation, String>((ref, bookingId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookingLocation(bookingId);
});
