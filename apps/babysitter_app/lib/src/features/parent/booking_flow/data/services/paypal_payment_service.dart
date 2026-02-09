import 'package:dio/dio.dart';
import '../models/paypal_models.dart';

/// Service for PayPal payment operations
class PaypalPaymentService {
  final Dio _authDio;
  final Dio _publicDio;

  PaypalPaymentService({
    required Dio authDio,
    required Dio publicDio,
  })  : _authDio = authDio,
        _publicDio = publicDio;

  /// Get PayPal configuration (sandbox/live mode)
  /// No authentication required
  Future<PaypalConfig> getConfig() async {
    try {
      final response = await _publicDio.get('/payments/paypal/config');
      return PaypalConfig.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a PayPal order for a draft job
  /// Returns: orderId, approvalUrl, amount, platformFee
  ///
  /// Error cases:
  /// - 400: Job not in draft status
  /// - 401: Not authenticated
  Future<PaypalOrder> createOrder(String jobId) async {
    try {
      final response = await _authDio.post(
        '/payments/paypal/create-order',
        data: {'jobId': jobId},
      );
      return PaypalOrder.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Capture a PayPal payment after user approval
  /// Must be called after deep link success with orderId
  ///
  /// Error cases:
  /// - 400: Order not approved / amount mismatch / orderId mismatch
  /// - 401: Not authenticated
  Future<PaypalCaptureResult> captureOrder({
    required String jobId,
    required String orderId,
  }) async {
    try {
      final response = await _authDio.post(
        '/payments/paypal/capture',
        data: {
          'jobId': jobId,
          'orderId': orderId,
        },
      );
      return PaypalCaptureResult.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  PaypalError _handleError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    String message = 'Unknown error';
    String? detail;

    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? 'Request failed';
        detail = data['detail']?.toString();
      } else if (data is String) {
        message = data;
      }
    } else {
      message = e.message ?? 'Network error';
    }

    return PaypalError(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
