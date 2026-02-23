import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/bookings/data/bookings_data_di.dart';
import 'package:babysitter_app/src/features/bookings/domain/booking.dart';
import 'package:babysitter_app/src/features/sitters/data/sitters_data_di.dart';
import 'package:babysitter_app/src/features/parent/search/utils/location_helper.dart';
import 'package:babysitter_app/src/features/parent/search/models/sitter_list_item_model.dart';

final parentHomeBookingsProvider =
    FutureProvider<List<Booking>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookings();
});

final parentHomeSittersProvider =
    FutureProvider<List<SitterListItemModel>>((ref) async {
  final repository = ref.watch(sittersRepositoryProvider);
  final (latitude, longitude) =
      await LocationHelper.getLocation(requestPermission: false);
  return repository.fetchSitters(
    latitude: latitude,
    longitude: longitude,
  );
});
