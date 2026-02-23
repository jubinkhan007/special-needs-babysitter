/// Response from GET /payments/paypal/config
class PaypalConfig {
  final String clientId;
  final String mode; // 'sandbox' or 'live'

  const PaypalConfig({
    required this.clientId,
    required this.mode,
  });

  factory PaypalConfig.fromJson(Map<String, dynamic> json) {
    return PaypalConfig(
      clientId: json['clientId'] as String,
      mode: json['mode'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'mode': mode,
      };

  bool get isSandbox => mode == 'sandbox';
}

/// Response from POST /payments/paypal/create-order
class PaypalOrder {
  final String orderId;
  final String approvalUrl;
  final int amount; // cents
  final int platformFee; // cents

  const PaypalOrder({
    required this.orderId,
    required this.approvalUrl,
    required this.amount,
    required this.platformFee,
  });

  factory PaypalOrder.fromJson(Map<String, dynamic> json) {
    return PaypalOrder(
      orderId: json['orderId'] as String,
      approvalUrl: json['approvalUrl'] as String,
      amount: json['amount'] as int,
      platformFee: json['platformFee'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'approvalUrl': approvalUrl,
        'amount': amount,
        'platformFee': platformFee,
      };

  double get amountDollars => amount / 100.0;
  double get platformFeeDollars => platformFee / 100.0;
}

/// Response from POST /payments/paypal/capture
class PaypalCaptureResult {
  final bool success;
  final String jobId;
  final String? applicationId;
  final String status;
  final String message;

  const PaypalCaptureResult({
    required this.success,
    required this.jobId,
    this.applicationId,
    required this.status,
    required this.message,
  });

  factory PaypalCaptureResult.fromJson(Map<String, dynamic> json) {
    return PaypalCaptureResult(
      success: json['success'] as bool,
      jobId: json['jobId'] as String,
      applicationId: json['applicationId'] as String?,
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'jobId': jobId,
        'applicationId': applicationId,
        'status': status,
        'message': message,
      };

  bool get isPosted => status == 'posted';
}

/// Error response from PayPal endpoints
class PaypalError implements Exception {
  final int statusCode;
  final String message;
  final String? detail;

  const PaypalError({
    required this.statusCode,
    required this.message,
    this.detail,
  });

  bool get isJobNotDraft => statusCode == 400 && message.contains('draft');
  bool get isUnauthorized => statusCode == 401;
  bool get isOrderNotApproved =>
      statusCode == 400 && message.contains('approved');

  @override
  String toString() => 'PaypalError($statusCode): $message';
}
