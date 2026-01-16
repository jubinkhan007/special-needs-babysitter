import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/booking_details.dart';
import '../../data/bookings_data_di.dart';

final bookingDetailsProvider =
    FutureProvider.family<BookingDetails, String>((ref, bookingId) {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookingDetails(bookingId);
});
