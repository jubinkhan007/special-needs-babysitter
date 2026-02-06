import 'package:dio/dio.dart';

import '../models/wallet_balance_model.dart';
import '../models/wallet_withdraw_response.dart';

class WalletApiService {
  final Dio _dio;

  WalletApiService(this._dio);

  Future<WalletBalanceModel> getBalance() async {
    final response = await _dio.get('/wallet/balance');
    final data = _unwrapMap(response.data);
    return WalletBalanceModel.fromJson(data);
  }

  Future<WalletWithdrawResponse> withdraw(int amountCents) async {
    final response = await _dio.post(
      '/wallet/withdraw',
      data: {
        'amount': amountCents,
      },
    );
    final data = _unwrapMap(response.data);
    return WalletWithdrawResponse.fromJson(data);
  }

  Map<String, dynamic> _unwrapMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        return nested;
      }
      return data;
    }
    return {};
  }
}
