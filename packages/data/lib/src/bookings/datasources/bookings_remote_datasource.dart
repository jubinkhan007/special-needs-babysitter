import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

/// Remote data source for booking operations
class BookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  /// POST /direct-bookings - Create a direct booking with a sitter
  Future<BookingResult> createDirectBooking(Map<String, dynamic> data) async {
    try {
      print('DEBUG: BookingsRemoteDataSource.createDirectBooking payload: $data');
      print('DEBUG: Payload as JSON: ${jsonEncode(data)}');
      print('DEBUG: Payload keys: ${data.keys.toList()}');
      print('DEBUG: Address keys: ${(data['address'] as Map?)?.keys.toList()}');
      print('DEBUG: EmergencyContact keys: ${(data['emergencyContact'] as Map?)?.keys.toList()}');
      final response = await _dio.post(
        '/direct-bookings',
        data: data,
      );

      print(
          'DEBUG: BookingsRemoteDataSource.createDirectBooking response: ${response.data}',);

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
      final response = await _dio.post(
        '/payments/create-intent',
        data: {'jobId': jobId},
      );

      // Handle both wrapped {success, data} and direct response formats
      final responseData = response.data;
      Map<String, dynamic> resultData;

      if (responseData['success'] == true && responseData['data'] != null) {
        // Wrapped format: {success: true, data: {...}}
        resultData = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['clientSecret'] != null) {
        // Direct format: {clientSecret, paymentIntentId, ...}
        resultData = responseData as Map<String, dynamic>;
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to create payment intent',);
      }

      return PaymentIntentResult(
        clientSecret: resultData['clientSecret'] ?? '',
        paymentIntentId: resultData['paymentIntentId'] ?? '',
      );
    } catch (e) {
      if (e is DioException) {
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
          'DEBUG: BookingsRemoteDataSource.cancelDirectBooking bookingId: $bookingId',);
      final response = await _dio.post(
        '/direct-bookings/$bookingId/cancel',
      );

      print(
          'DEBUG: BookingsRemoteDataSource.cancelDirectBooking response: ${response.data}',);

      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to cancel booking');
      }
    } catch (e) {
      if (e is DioException) {
        print(
            'DEBUG: BookingsRemoteDataSource cancelDirectBooking DioError: ${e.response?.data}',);
        final errorData = e.response?.data;
        if (errorData is Map && errorData['error'] != null) {
          throw Exception(errorData['error']);
        }
      }
      rethrow;
    }
  }
}
