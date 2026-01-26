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
}
