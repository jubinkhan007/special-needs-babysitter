import '../../domain/entities/wallet_balance.dart';

class WalletBalanceModel extends WalletBalance {
  const WalletBalanceModel({
    required super.balanceCents,
    required super.availableForWithdrawalCents,
    super.balanceInDollars,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final map = data is Map<String, dynamic> ? data : json;

    return WalletBalanceModel(
      balanceCents: _parseInt(map['balance']),
      availableForWithdrawalCents: _parseInt(map['availableForWithdrawal']),
      balanceInDollars: map['balanceInDollars'] as String?,
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
