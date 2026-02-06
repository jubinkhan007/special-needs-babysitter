import '../../domain/entities/wallet_withdraw_result.dart';

class WalletWithdrawResponse extends WalletWithdrawResult {
  const WalletWithdrawResponse({
    required super.success,
    required super.amountCents,
    super.transferId,
    super.amountInDollars,
    super.estimatedArrival,
  });

  factory WalletWithdrawResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final map = data is Map<String, dynamic> ? data : json;

    return WalletWithdrawResponse(
      success: map['success'] == true,
      transferId: map['transferId'] as String?,
      amountCents: _parseInt(map['amount']),
      amountInDollars: map['amountInDollars'] as String?,
      estimatedArrival: map['estimatedArrival'] as String?,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
