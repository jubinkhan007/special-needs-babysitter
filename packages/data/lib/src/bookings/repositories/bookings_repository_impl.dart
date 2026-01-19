import 'package:domain/domain.dart';
import '../datasources/bookings_remote_datasource.dart';

/// Implementation of [BookingsRepository]
class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<BookingResult> createDirectBooking(Map<String, dynamic> data) async {
    return _remoteDataSource.createDirectBooking(data);
  }

  @override
  Future<PaymentIntentResult> createPaymentIntent(String jobId) async {
    return _remoteDataSource.createPaymentIntent(jobId);
  }

  @override
  Future<void> cancelDirectBooking(String bookingId) async {
    return _remoteDataSource.cancelDirectBooking(bookingId);
  }
}
