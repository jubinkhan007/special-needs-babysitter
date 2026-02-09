import 'package:shared_preferences/shared_preferences.dart';

/// Persists pending PayPal payment state to SharedPreferences.
/// This ensures capture works even if app restarts during PayPal flow.
class PaypalPendingState {
  static const _keyJobId = 'paypal_pending_job_id';
  static const _keyOrderId = 'paypal_pending_order_id';

  /// Save pending PayPal payment state before opening browser
  static Future<void> save({
    required String jobId,
    required String orderId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyJobId, jobId);
    await prefs.setString(_keyOrderId, orderId);
    print('DEBUG: PayPal pending state saved: jobId=$jobId, orderId=$orderId');
  }

  /// Get pending PayPal payment state
  /// Returns (jobId, orderId) tuple, or (null, null) if not set
  static Future<({String? jobId, String? orderId})> get() async {
    final prefs = await SharedPreferences.getInstance();
    final jobId = prefs.getString(_keyJobId);
    final orderId = prefs.getString(_keyOrderId);
    print('DEBUG: PayPal pending state loaded: jobId=$jobId, orderId=$orderId');
    return (jobId: jobId, orderId: orderId);
  }

  /// Clear pending PayPal payment state after success or cancel
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyJobId);
    await prefs.remove(_keyOrderId);
    print('DEBUG: PayPal pending state cleared');
  }

  /// Check if there's pending PayPal payment state
  static Future<bool> hasPending() async {
    final state = await get();
    return state.jobId != null && state.orderId != null;
  }
}
