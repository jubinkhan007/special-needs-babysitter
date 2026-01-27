import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import '../../../constants/app_constants.dart';
import '../../bookings/domain/bookings_repository.dart';
import 'datasources/bookings_remote_datasource.dart';
import 'datasources/google_geocoding_remote_datasource.dart';
import 'repositories/bookings_repository_impl.dart';

// Dio Provider for Bookings
final bookingsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add Auth Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final authState = ref.read(authNotifierProvider);
      var session = authState.valueOrNull;

      if (session == null) {
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          options.headers['Cookie'] = 'session_id=$storedToken';
        }
      } else {
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      return handler.next(e);
    },
  ));

  return dio;
});

// Remote Data Source Provider
final bookingsRemoteDataSourceProvider =
    Provider<BookingsRemoteDataSource>((ref) {
  return BookingsRemoteDataSource(ref.watch(bookingsDioProvider));
});

final googleGeocodingDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com/maps/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});

final googleGeocodingRemoteDataSourceProvider =
    Provider<GoogleGeocodingRemoteDataSource>((ref) {
  return GoogleGeocodingRemoteDataSource(
    ref.watch(googleGeocodingDioProvider),
  );
});

// Repository Provider
final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepositoryImpl(ref.watch(bookingsRemoteDataSourceProvider));
});
