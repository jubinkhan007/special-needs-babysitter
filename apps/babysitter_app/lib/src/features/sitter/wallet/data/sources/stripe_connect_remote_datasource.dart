import 'package:dio/dio.dart';

import '../models/stripe_connect_status.dart';

class StripeConnectRemoteDataSource {
  final Dio _dio;

  StripeConnectRemoteDataSource(this._dio);

  /// Get the current Stripe Connect account status
  Future<StripeConnectStatus> getConnectStatus() async {
    try {
      print('DEBUG: Stripe Connect Request: GET /stripe-connect/status');
      final response = await _dio.get(
        '/stripe-connect/status',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print('DEBUG: Stripe Connect Status Response: ${response.statusCode}');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Handle wrapped response
        final statusData = data['data'] ?? data;
        return StripeConnectStatus.fromJson(statusData as Map<String, dynamic>);
      }

      // Return not started if no valid data
      return const StripeConnectStatus(
        status: StripeConnectStatusType.notStarted,
      );
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Stripe Connect Status Error: ${e.message}');
        print('DEBUG: Stripe Connect Status Error Response: ${e.response?.data}');

        // If 404, treat as not started (no account yet)
        if (e.response?.statusCode == 404) {
          return const StripeConnectStatus(
            status: StripeConnectStatusType.notStarted,
          );
        }

        if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'The request is taking longer than expected. Please try again.',
          );
        }
      }
      rethrow;
    }
  }

  /// Get the onboarding URL to start or continue Stripe Connect setup
  /// Returns the URL string and optionally the account ID
  Future<String> getOnboardingUrl() async {
    try {
      print('DEBUG: Stripe Connect Request: POST /stripe-connect/onboard');
      final response = await _dio.post(
        '/stripe-connect/onboard',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print('DEBUG: Stripe Connect Onboard Response: ${response.statusCode}');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final url = data['url'] as String?;
        if (url != null && url.isNotEmpty) {
          return url;
        }
      }

      throw Exception('Failed to get onboarding URL from server');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Stripe Connect Onboard Error: ${e.message}');
        print('DEBUG: Stripe Connect Onboard Error Response: ${e.response?.data}');

        if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'The request is taking longer than expected. Please try again.',
          );
        }
      }
      rethrow;
    }
  }

  /// Get the Stripe Express Dashboard URL for onboarded users
  Future<String> getDashboardUrl() async {
    try {
      print('DEBUG: Stripe Connect Request: POST /stripe-connect/dashboard');
      final response = await _dio.post(
        '/stripe-connect/dashboard',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print('DEBUG: Stripe Connect Dashboard Response: ${response.statusCode}');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final url = data['url'] as String?;
        if (url != null && url.isNotEmpty) {
          return url;
        }
      }

      throw Exception('Failed to get dashboard URL from server');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Stripe Connect Dashboard Error: ${e.message}');
        print('DEBUG: Stripe Connect Dashboard Error Response: ${e.response?.data}');

        if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'The request is taking longer than expected. Please try again.',
          );
        }
      }
      rethrow;
    }
  }
}
