import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bookings/data/bookings_data_di.dart'; // Reuse Dio with Auth Interceptor
import 'datasources/sitters_remote_datasource.dart';
import 'repositories/sitters_repository_impl.dart';
import '../domain/sitters_repository.dart';

// Reuse the authenticated dio client from bookings if possible,
// or define a shared one. bookingsDioProvider is available.
final sittersRemoteDataSourceProvider =
    Provider<SittersRemoteDataSource>((ref) {
  final dio = ref.watch(bookingsDioProvider);
  return SittersRemoteDataSource(dio);
});

final sittersRepositoryProvider = Provider<SittersRepository>((ref) {
  final dataSource = ref.watch(sittersRemoteDataSourceProvider);
  return SittersRepositoryImpl(dataSource);
});
