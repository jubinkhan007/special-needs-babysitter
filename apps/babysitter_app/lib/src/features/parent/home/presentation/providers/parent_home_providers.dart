import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../bookings/data/bookings_data_di.dart';
import '../../../../bookings/domain/booking.dart';
import '../../../../sitters/data/sitters_data_di.dart';
import '../../../search/utils/location_helper.dart';
import '../../../search/models/sitter_list_item_model.dart';

final parentHomeBookingsProvider =
    FutureProvider.autoDispose<List<Booking>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getBookings();
});

final parentHomeSittersProvider =
    FutureProvider.autoDispose<List<SitterListItemModel>>((ref) async {
  final repository = ref.watch(sittersRepositoryProvider);
  final (latitude, longitude) = await LocationHelper.getLocation();
  return repository.fetchSitters(
    latitude: latitude,
    longitude: longitude,
  );
});
