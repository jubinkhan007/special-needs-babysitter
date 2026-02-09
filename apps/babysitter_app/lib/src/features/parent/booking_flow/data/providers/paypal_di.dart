import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:auth/auth.dart'; // For authDioProvider
import 'package:core/core.dart'; // For Constants.baseUrl

import '../services/paypal_payment_service.dart';

/// Provider for a public Dio instance (no auth required)
/// Used for GET /payments/paypal/config which doesn't need authentication
final _publicDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
});

/// Provider for PaypalPaymentService
final paypalPaymentServiceProvider = Provider<PaypalPaymentService>((ref) {
  final authDio = ref.watch(authDioProvider);
  final publicDio = ref.watch(_publicDioProvider);
  return PaypalPaymentService(
    authDio: authDio,
    publicDio: publicDio,
  );
});
