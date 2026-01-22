import '../../domain/repositories/bookings_repository.dart';
import '../models/booking_model.dart';
import '../sources/bookings_remote_datasource.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BookingModel>> getBookings({String? tab}) {
    return _remoteDataSource.getBookings(tab: tab);
  }
}
