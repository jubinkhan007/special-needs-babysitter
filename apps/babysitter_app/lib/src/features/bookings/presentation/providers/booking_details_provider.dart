import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/bookings/domain/booking_details.dart';
import 'package:babysitter_app/src/features/bookings/data/bookings_data_di.dart';

final bookingDetailsProvider =
    FutureProvider.family<BookingDetails, String>((ref, bookingId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookingDetails(bookingId);
});
