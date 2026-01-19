import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

/// Remote data source for booking operations
class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  /// POST /direct-bookings - Create a direct booking with a sitter
  Future<BookingResult> createDirectBooking(Map<String, dynamic> data) async {
    try {
      print(
          'DEBUG: BookingsRemoteDataSource.createDirectBooking payload: $data');
      final response = await _dio.post(
        '/direct-bookings',
        data: data,
      );

      print(
          'DEBUG: BookingsRemoteDataSource.createDirectBooking response: ${response.data}');

      if (response.data['success'] == true) {
        final resultData = response.data['data'] as Map<String, dynamic>;
        return BookingResult(
          message: resultData['message'] ?? 'Booking created',
          jobId: resultData['jobId'] ?? '',
          clientSecret: resultData['clientSecret'] ?? '',
          paymentIntentId: resultData['paymentIntentId'] ?? '',
          amount: resultData['amount'] ?? 0,
          platformFee: resultData['platformFee'] ?? 0,
        );
      } else {
        throw Exception(response.data['error'] ?? 'Failed to create booking');
      }
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: BookingsRemoteDataSource DioError: ${e.response?.data}');
        final errorData = e.response?.data;
        if (errorData is Map && errorData['error'] != null) {
          throw Exception(errorData['error']);
        }
      }
      rethrow;
    }
  }

  /// POST /payments/create-intent - Create Stripe payment intent
  Future<PaymentIntentResult> createPaymentIntent(String jobId) async {
    try {
      print(
          'DEBUG: BookingsRemoteDataSource.createPaymentIntent jobId: $jobId');
      final response = await _dio.post(
        '/payments/create-intent',
        data: {'jobId': jobId},
      );

      print(
          'DEBUG: BookingsRemoteDataSource.createPaymentIntent response: ${response.data}');

      if (response.data['success'] == true) {
        final resultData = response.data['data'] as Map<String, dynamic>;
        return PaymentIntentResult(
          clientSecret: resultData['clientSecret'] ?? '',
          paymentIntentId: resultData['paymentIntentId'] ?? '',
        );
      } else {
        throw Exception(
            response.data['error'] ?? 'Failed to create payment intent');
      }
    } catch (e) {
      if (e is DioException) {
        print(
            'DEBUG: BookingsRemoteDataSource createPaymentIntent DioError: ${e.response?.data}');
        final errorData = e.response?.data;
        if (errorData is Map && errorData['error'] != null) {
          throw Exception(errorData['error']);
        }
      }
      rethrow;
    }
  }

  /// POST /direct-bookings/{id}/cancel - Cancel a direct booking
  Future<void> cancelDirectBooking(String bookingId) async {
    try {
      print(
          'DEBUG: BookingsRemoteDataSource.cancelDirectBooking bookingId: $bookingId');
      final response = await _dio.post(
        '/direct-bookings/$bookingId/cancel',
      );

      print(
          'DEBUG: BookingsRemoteDataSource.cancelDirectBooking response: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to cancel booking');
      }
    } catch (e) {
      if (e is DioException) {
        print(
            'DEBUG: BookingsRemoteDataSource cancelDirectBooking DioError: ${e.response?.data}');
        final errorData = e.response?.data;
        if (errorData is Map && errorData['error'] != null) {
          throw Exception(errorData['error']);
        }
      }
      rethrow;
    }
  }
}
