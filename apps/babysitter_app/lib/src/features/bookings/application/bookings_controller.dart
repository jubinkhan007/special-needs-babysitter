import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/booking.dart';
import '../domain/booking_status.dart';
import '../../bookings/data/bookings_data_di.dart';
import '../../bookings/domain/bookings_repository.dart';

class BookingsController extends ChangeNotifier {
  final BookingsRepository _repository;
  List<Booking> _bookings = [];
  bool _isLoading = false;

  BookingsController(this._repository) {
    _loadBookings();
  }

  List<Booking> get allBookings => _bookings;
  bool get isLoading => _isLoading;

  List<Booking> bookingsFor(BookingStatus status) {
    if (status == BookingStatus.active) {
      return _bookings
          .where((b) =>
              b.status == BookingStatus.active ||
              b.status == BookingStatus.clockedOut)
          .toList();
    }
    return _bookings.where((b) => b.status == status).toList();
  }

  Future<void> _loadBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookings = await _repository.getBookings();
    } catch (e) {
      print('DEBUG: Failed to load bookings: $e');
      // Keep empty list or handle error silently as UI has no error state logic
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh method if needed
  Future<void> refresh() => _loadBookings();
}

final bookingsControllerProvider =
    ChangeNotifierProvider<BookingsController>((ref) {
  return BookingsController(ref.watch(bookingsRepositoryProvider));
});
