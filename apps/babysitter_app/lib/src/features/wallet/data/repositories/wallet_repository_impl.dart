import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_balance.dart';
import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_withdraw_result.dart';
import 'package:babysitter_app/src/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:babysitter_app/src/features/wallet/data/services/wallet_api_service.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiService _service;

  WalletRepositoryImpl(this._service);

  @override
  Future<WalletBalance> getBalance() async {
    return _service.getBalance();
  }

  @override
  Future<WalletWithdrawResult> withdraw(int amountCents) async {
    return _service.withdraw(amountCents);
  }
}
