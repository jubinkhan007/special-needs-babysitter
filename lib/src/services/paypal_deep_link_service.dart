import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Events emitted by the PayPal deep link service
sealed class PaypalDeepLinkEvent {}

/// PayPal payment was approved - orderId is extracted from URL
class PaypalPaymentSuccess extends PaypalDeepLinkEvent {
  final String orderId;
  PaypalPaymentSuccess(this.orderId);
}

/// PayPal payment was cancelled by user
class PaypalPaymentCancelled extends PaypalDeepLinkEvent {}

/// Service to handle PayPal deep links
///
/// Listens for:
/// - `specialsitters://payment/paypal/success?orderId=...`
/// - `specialsitters://payment/paypal/cancel`
class PaypalDeepLinkService {
  static PaypalDeepLinkService? _instance;
  static PaypalDeepLinkService get instance {
    _instance ??= PaypalDeepLinkService._();
    return _instance!;
  }

  PaypalDeepLinkService._();

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  final _eventController = StreamController<PaypalDeepLinkEvent>.broadcast();

  /// Stream of PayPal deep link events
  Stream<PaypalDeepLinkEvent> get events => _eventController.stream;

  /// Initialize the deep link service
  /// Should be called once at app startup
  Future<void> init() async {
    _appLinks = AppLinks();

    // Handle initial link (app was opened via deep link from terminated state)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('DEBUG: PaypalDeepLinkService initial link: $initialUri');
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('DEBUG: PaypalDeepLinkService failed to get initial link: $e');
    }

    // Handle links while app is running
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('DEBUG: PaypalDeepLinkService received link: $uri');
      _handleUri(uri);
    }, onError: (e) {
      debugPrint('DEBUG: PaypalDeepLinkService stream error: $e');
    });
  }

  void _handleUri(Uri uri) {
    // Check if this is a PayPal callback
    // Expected: specialsitters://payment/paypal/success?orderId=...
    // Or: specialsitters://payment/paypal/cancel

    if (uri.scheme != 'specialsitters') {
      debugPrint('DEBUG: PaypalDeepLinkService ignoring non-specialsitters scheme');
      return;
    }

    if (uri.host != 'payment') {
      debugPrint('DEBUG: PaypalDeepLinkService ignoring non-payment host');
      return;
    }

    final path = uri.path;

    if (path.contains('/paypal/success')) {
      final orderId = uri.queryParameters['orderId'];
      if (orderId != null && orderId.isNotEmpty) {
        debugPrint(
            'DEBUG: PaypalDeepLinkService emitting success with orderId=$orderId');
        _eventController.add(PaypalPaymentSuccess(orderId));
      } else {
        debugPrint(
            'DEBUG: PaypalDeepLinkService success without orderId, treating as cancel');
        _eventController.add(PaypalPaymentCancelled());
      }
    } else if (path.contains('/paypal/cancel')) {
      debugPrint('DEBUG: PaypalDeepLinkService emitting cancel');
      _eventController.add(PaypalPaymentCancelled());
    } else {
      debugPrint('DEBUG: PaypalDeepLinkService ignoring unknown path: $path');
    }
  }

  /// Dispose of resources
  void dispose() {
    _subscription?.cancel();
    _eventController.close();
  }
}
