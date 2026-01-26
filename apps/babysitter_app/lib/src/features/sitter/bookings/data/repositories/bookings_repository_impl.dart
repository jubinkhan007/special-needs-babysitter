import '../../domain/repositories/bookings_repository.dart';
import '../models/booking_model.dart';
import '../models/booking_session_model.dart';
import '../sources/bookings_remote_datasource.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BookingModel>> getBookings({String? tab}) {
    return _remoteDataSource.getBookings(tab: tab);
  }

  @override
  Future<BookingSessionModel> getBookingSession(String applicationId) {
    return _remoteDataSource.getBookingSession(applicationId);
  }

  @override
  Future<void> postBookingLocation(
    String applicationId, {
    required double latitude,
    required double longitude,
  }) {
    return _remoteDataSource.postBookingLocation(
      applicationId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<DateTime> pauseBooking(String applicationId, {required String reason}) {
    return _remoteDataSource.pauseBooking(applicationId, reason: reason);
  }

  @override
  Future<void> resumeBooking(String applicationId) {
    return _remoteDataSource.resumeBooking(applicationId);
  }
}
