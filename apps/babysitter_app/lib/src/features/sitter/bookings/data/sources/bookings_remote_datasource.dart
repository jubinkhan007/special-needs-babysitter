import 'package:dio/dio.dart';

import '../models/booking_model.dart';

/// Remote data source for bookings API calls.
class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  /// Get sitter's bookings via GET /sitters/bookings.
  Future<List<BookingModel>> getBookings({String? tab}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tab != null) {
        queryParams['tab'] = tab;
      }

      print('DEBUG: Sitter Bookings Request: GET /sitters/bookings${queryParams.isNotEmpty ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}' : ''}');
      final response = await _dio.get(
        '/sitters/bookings',
        queryParameters: queryParams,
      );
      print('DEBUG: Sitter Bookings Response Status: ${response.statusCode}');

      final data = response.data['data'] as Map<String, dynamic>;
      final bookings = data['bookings'] as List;

      return bookings
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Sitter Bookings Error: ${e.message}');
        print('DEBUG: Sitter Bookings Error Response: ${e.response?.data}');
        print(
            'DEBUG: Sitter Bookings Error Headers: ${e.requestOptions.headers}');

        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}
